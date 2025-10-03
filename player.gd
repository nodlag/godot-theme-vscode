class_name Player
extends BaseCardObject

# --- SIGNALS

# --- ENUMS
enum MovementState {
	IDLE,
	MOVING_BACK,
	MOVING_TO_TARGET
}

# --- CONSTANTS
const MOVING_BACK_SPEED: float = 10.0
const MOVING_TARGET_SPEED: float = 20.0

# --- EXPORT VARS
@export_group("Local References")
@export var player_state_machine: PlayerStateMachine
@export var drop_area_2d: Area2D

# --- VARS
var previous_position: Vector2
var movement_state: MovementState = MovementState.IDLE
var target_position: Vector2
var is_selected: bool = false # for animation only

# Tweens
var tween_motion_scale: Tween
var tween_motion_attack_movement: Tween
var tween_motion_rotation: Tween

# --- BUILT-IN METHODS
func _ready() -> void:
	# Connect signals
	self.gui_input.connect(_on_gui_input)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	drop_area_2d.area_entered.connect(_on_drop_area_2d_area_entered)
	drop_area_2d.area_exited.connect(_on_drop_area_2d_area_exited)
	card_visuals.animation_attack_finished.connect(_on_card_visuals_animation_attack_finished)
	
	# Setup
	player_state_machine.init(self)


func _process(delta: float) -> void:
	_process_movement(delta)
	_process_motion(delta)


func _input(event: InputEvent) -> void:
	if GameplayEvents.movement_locked:
		return
		
	player_state_machine.on_input(event)


func _exit_tree() -> void:
	# Disconnect signals
	self.gui_input.disconnect(_on_gui_input)
	self.mouse_entered.disconnect(_on_mouse_entered)
	self.mouse_exited.disconnect(_on_mouse_exited)
	drop_area_2d.area_entered.disconnect(_on_drop_area_2d_area_entered)
	drop_area_2d.area_exited.disconnect(_on_drop_area_2d_area_exited)
	card_visuals.animation_attack_finished.disconnect(_on_card_visuals_animation_attack_finished)


# --- OVERRIDDEN CUSTOM METHODS
func _update_card_stats() -> void:
	card_visuals.setup(self, _card_stats)


func die() -> void:
	GameplayEvents.emit_gameover()
	queue_free()


# --- METHODS
func init(initial_grid_position: Vector2i) -> void:
	set_grid_position(initial_grid_position)
	previous_position = position
	set_rotation_degrees(randf_range(-card_start_rotation_degrees, card_start_rotation_degrees))
	_init_motion()


func _init_motion() -> void:
	motion_last_position = global_position
	motion_current_rotation = Vector2.ZERO


func _process_movement(delta: float) -> void:
	match movement_state:
		MovementState.IDLE:
			pass
		
		MovementState.MOVING_BACK:
			var distance: float = position.distance_to(previous_position)
			if distance > 1.0:
				position = position.lerp(previous_position, MOVING_BACK_SPEED * delta)
			else:
				movement_state = MovementState.IDLE
				GameplayEvents.remove_node_with_action_running(self)

		MovementState.MOVING_TO_TARGET:
			global_position = global_position.lerp(target_position, MOVING_TARGET_SPEED * delta)


func attack() -> void:
	# TODO: Calculate the fight with the "target"
	run_animation_attack()


func move_back() -> void:
	#_on_mouse_exited()
	movement_state = MovementState.MOVING_BACK
	GameplayEvents.add_node_with_action_running(self)


func run_animation_attack() -> void:
	# Add action running
	GameplayEvents.add_node_with_action_running(self)
	# Encapsulated in CardVisuals
	card_visuals.run_animation_attack_to_target(target, motion_current_rotation)


func run_animation_select() -> void:
	if not is_selected:
		card_visuals.run_animation_select()
	
	is_selected = true


func run_animation_unselect() -> void:
	if is_selected:
		card_visuals.run_animation_unselect()
	
	is_selected = false


#region Callbacks
func _on_gui_input(event: InputEvent) -> void:
	if GameplayEvents.movement_locked:
		return
	
	player_state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	if GameplayEvents.movement_locked:
		return
	
	if player_state_machine.current_state.state == PlayerState.State.DRAGGING:
		return
	
	player_state_machine.on_mouse_entered()
	if Utils.is_desktop():
		run_animation_select()


func _on_mouse_exited() -> void:
	if GameplayEvents.movement_locked:
		return
	
	if player_state_machine.current_state.state == PlayerState.State.DRAGGING:
		return
	
	motion_current_rotation = Vector2.ZERO
	player_state_machine.on_mouse_exited()
	run_animation_unselect()


func _on_drop_area_2d_area_entered(area: Area2D) -> void:
	# Set target
	target = area.get_parent()
	print(target)
	
	var card_object: CardObject = target as CardObject
	if card_object != null:
		card_object.set_target(self)


func _on_drop_area_2d_area_exited(_area: Area2D) -> void:
	# Remove target
	var card_object: CardObject = target as CardObject
	if card_object != null:
		card_object.remove_target()
	
	target = null


func _on_card_visuals_animation_attack_finished() -> void:
	# Handle the attack animation finished
	print("Attack animation finished")
	execute_attack_to_target()
	GameplayEvents.emit_player_attack(target)

	# Remove action running
	GameplayEvents.remove_node_with_action_running(self)

#endregion
