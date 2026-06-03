# Color reference — Godot ↔ Godot Theme VSCode

This document is the **source of truth** for the themes' colors. The themes in
[themes/](themes/) reproduce the Godot editor palette. The originating C++ code lives in
`godot-master/` (Godot 4.6+).

Use it to audit existing themes or to **create new themes** (see the recipe at the end).

---

## 1. How Godot generates colors

Each preset defines only **3 inputs**; everything else is derived by formula:

| Input | Meaning |
|---|---|
| `accent_color` | highlight color (selection, active borders, badges) |
| `base_color` | base surface color (panels, backgrounds) |
| `contrast` | `0.3` by default (`default_contrast`) for all dark themes |

**Sources in `godot-master/`:**
- Presets (accent/base/contrast): `editor/themes/editor_theme_manager.cpp:326-362`
- UI derivation formulas: `editor/themes/theme_modern.cpp:53-211` (helper `_get_base_color` `:45`)
- **Default** theme syntax (dark): `editor/themes/editor_theme_manager.cpp:495-560`
- **Godot 2** theme syntax: `editor/settings/editor_settings.cpp:1862-1922`
- `default_contrast = 0.3`: `editor/themes/editor_theme_manager.h:87`

**float→hex conversion:** `component * 255`, rounded to the nearest integer (`round(x*255)`),
2 hex digits. Alpha likewise. `lerp(a,b,t) = a + (b-a)*t` per channel.

---

## 2. Presets (inputs) — exact Godot hex

| Preset | base_color (Godot) | accent_color (Godot) | contrast |
|---|---|---|---|
| Default | `Color(0.161,0.161,0.161)` = `#292929` | `Color(0.337,0.62,1.0)` = `#569eff` | 0.3 |
| Breeze Dark | `Color(0.1255,0.1373,0.149)` = `#202326` | `Color(0.239,0.682,0.914)` = `#3daee9` | 0.3 |
| Godot 2 | `Color(0.24,0.23,0.27)` = `#3d3b45` | `Color(0.53,0.67,0.89)` = `#87abe3` | 0.3 |
| Godot 3 | `Color(0.21,0.24,0.29)` = `#363d4a` | `Color(0.44,0.73,0.98)` = `#70bafa` | 0.3 |
| **Gray** | `Color(0.24,0.24,0.24)` = `#3d3d3d` | `Color(0.44,0.73,0.98)` = `#70bafa` | 0.3 |
| Black (OLED) | `#000000` | `#73bfff` | 0.0 |
| Light | `#e6e6e6` | `#2e80ff` | −0.06 |

> Gray shares its `accent_color` with Godot 3; only the `base_color` changes (neutral gray).

---

## 3. Syntax (Point 1) — **Default** theme (dark)

Exact Godot hex → VS Code token(s) (`semanticTokenColors`). This is the **current** palette after
the corrections; identical across all Modern themes.

| Godot color (dark) | hex | VS Code token |
|---|---|---|
| `symbol_color` | `#abc9ff` | `operator`, `editorBracketHighlight.*` |
| `keyword_color` | `#ff7085` | `keyword`, `boolean` |
| `control_flow_keyword_color` | `#ff8ccc` | `controlKeyword` |
| `base_type_color` | `#42ffc2` | `type`, `struct`, `typeParameter`, `enum`, `interface` |
| `engine_type_color` | `#8fffdb` | `class`, `namespace` |
| `user_type_color` | `#c7ffed` | user-defined types (several `tokenColors` entries) |
| `member_variable_color` | `#bce0ff` | `variable`, `property`, `parameter` |
| `function_color` | `#57b3ff` | `function`, `method` |
| `number_color` | `#a1ffe0` | `number` |
| `string_color` | `#ffeda1` | `string` |
| `comment_color` (= white·0.5) | `#ffffff80` | `comment` |
| `doc_comment_color` | `#99b3cc` (α≈0.8) | docstrings |
| `string_placeholder_color` | `#ffbf66` | string placeholders |
| `gdscript/annotation_color` | `#ffb373` | `decorator`, `enumMember`, `label`, `regexp` |
| `gdscript/function_definition_color` | `#66e6ff` | function definition |
| `gdscript/global_function_color` | `#a3a3f5` | global functions |
| `gdscript/node_path_color` | `#b8c47d` | node paths (`$Path`) |
| `gdscript/node_reference_color` | `#63c259` | node references |
| `gdscript/string_name_color` | `#ffc2a6` | `&"StringName"` |

> `macro`/`preprocessorText` (`#ad75c4`) have no equivalent in Godot's Default theme
> (relevant for C#/Mono, which has its own highlighting). Left as an author choice.

### **Godot 2** theme syntax (reference)
Godot defines a separate code palette for "Godot 2" (`get_godot2_text_editor_theme`).
**`godot-2.json` does NOT currently use it** (it inherits Default's). Reference hex in case it is
ever applied:

| Color | hex | | Color | hex |
|---|---|---|---|---|
| symbol | `#baddff` | | number | `#eb9433` |
| keyword | `#ffffb3` | | function | `#66a3cf` |
| control_flow | `#ffd9b3` | | member_variable | `#e64f59` |
| base_type | `#a3ffd4` | | comment | `#666666` |
| engine_type | `#82d4ff` | | string | `#f06ebf` |
| user_type | `#6babed` | | annotation | `#ffb373` |

---

## 4. UI (Point 3) — formulas and mapping to VS Code keys

Derived colors (dark theme, `contrast = 0.3`, `mono = white`):

| Godot color | Formula | VS Code key(s) |
|---|---|---|
| `base_color` | (input) | opaque `sideBar/statusBar/panel.* background` = base, `badge`, `tab.activeBackground`, widgets |
| editor background | `base.lerp(black, 0.36)` (`contrast·1.2`) | `editor.background`, `terminal.background`, `panel.background`, `peekViewEditor.background` |
| `font_color` | `white · 0.75` = `#ffffffbf` | `editor.foreground`, `foreground`, and every text `*.foreground` |
| `selection_color` | `accent · α0.4` | `editor.selectionBackground`, `selection.background` |
| `highlight_color` | `accent · α0.275` | `list.activeSelectionBackground`, `list.focusBackground` |
| accent (opaque) | (input) | `*.activeBorder`, `activityBarBadge`, `statusBar.debuggingBackground`, `pickerGroup`, `inputOption.activeBorder` |
| `current_line` / word highlight | `white · α0.07` = `#ffffff12` | `editor.lineHighlightBackground`, `editor.wordHighlightBackground`, `editor.hoverHighlightBackground` |
| `dark_color_1` | `base.lerp(black, 0.345)` | (Godot-internal; not mapped 1:1) |
| `dark_color_3` | `base` with value `·(1−0.24)` | (Godot-internal) |
| `contrast_color_1` | `base.lerp(white, 0.345)` | light borders |
| `contrast_color_2` | `base.lerp(white, 0.5175)` | strong light borders |
| `success` / `warning` / `error` (dark) | `#73f280` / `#d4c79e` / `#ff786b` | `editorError/Warning`, gitDecoration |

### Workbench surfaces that **don't** exist in Godot
VS Code has more surfaces (activityBar, titleBar, scrollbar, tabs, dropdowns…) that Godot does not
theme separately. The family generates them as `base · factor` (lerp toward black). Factors used
(measured against Default's neutral `base` = `#292929`):

| Shade | factor ×base | Default | usage |
|---|---|---|---|
| darkest | ×0.488 | `#141414` | scrollbar.shadow, activityBar/titleBar/dropdown bg, tab.border/inactive, panel.border |
| editor | ×0.634 | `#1a1a1a` | editor/terminal/panel background |
| input | ×0.683 | `#1c1c1c` | input.background |
| border | ×0.756 | `#1f1f1f` | input.border, editorGroup.border, peekViewTitle, settings borders |
| **base** | ×1.000 | `#292929` | sideBar/statusBar/widgets |
| section | ×1.390 | `#393939` | sideBarSectionHeader.background |
| button | ×1.610 | `#424242` | button.background |
| findRange | ×2.073 | `#555555` | editor.findRangeHighlightBackground |

> These factors are not Godot colors, but they keep the family consistent. For a new neutral base
> (e.g. Gray `#3d3d3d` = 61): surface = `round(61 × factor)`.

---

## 5. Fidelity status (current audit)

- **Syntax:** 1:1 with Godot Default (dark) across all Modern themes (after corrections).
- **Editor (bg, fg, selection, current line, word highlight) and accent:** 1:1 across the 5 Modern themes.
- **Godot 3 `base_color` aligned to Godot 1:1:** `#363d4a` (`Color(0.21,0.24,0.29)`), which makes
  `editor.background` = `#22272f` (`base·0.64` from float, rounded once). Previously the author used
  `#373d49`/`#23272e`. The three `commandCenter.*Border` keys (top menu bar / project-name pill) also
  held a `#3d3b44` leftover — that is **Godot 2's** `base_color` — and were corrected to Godot 3's
  base `#363d4a` (matching how Default/Gray set the command-center border to their own base).
- **Godot 3 darkest workbench group aligned to `base·0.488`:** `#1a1e24` (titleBar, activityBar,
  dropdown, scrollbar.shadow, tabs, panel.border…). The previous hand-set `#1c1f24` raised R/G while
  keeping B, compressing the blue tint so the title bar looked grayer than the rest of the palette.
- **Godot 3 `sideBarSectionHeader.background` aligned to `base·1.390`:** `#4b5567` (the Explorer
  section header where the project/workspace name shows). The previous `#525966` had the same
  grayness issue (R/G raised vs B). `sideBar.border` `#1a1e24` (=`base·0.488`) and the header text
  (inherits `sideBar.foreground` `#ffffffbf` = font_color) were already correct.
- **Breeze & Godot 2 `base_color` aligned to Godot 1:1:** Breeze `#202326` (`Color(0.1255,0.1373,0.149)`,
  was `#212326`); Godot 2 `#3d3b45` (`Color(0.24,0.23,0.27)`, was `#3d3b44`). Their `editor.background`
  (float `base·0.64`) was already exact.
- **All workbench surface groups regenerated from the exact `base`** for the 3 tinted themes (Breeze,
  Godot 2, Godot 3) using the canonical factor model that Default/Gray follow exactly (section 4):
  darkest `×0.488`, input.bg `×0.683`, input.border `×0.756`, section `×1.39`, button `×1.61`,
  findRange `×2.073`. Several were previously hand-set and ran grayer than the model (e.g. Breeze
  `findRange` `#4e5052` → `#42494f`; Godot 2 `findRange` `#706e78` → `#7e7a8f`). These surfaces have
  **no direct Godot equivalent** (VS Code-only: titleBar, activityBar, tabs, scrollbar, buttons,
  inputs, findRange…); "1:1" here means derived consistently from the Godot-exact `base`, identical
  to how the neutral Default/Gray themes derive theirs.
- **Out of model (author choices, no neutral reference):** a few tinted one-off surfaces exist only in
  the tinted themes and cannot be derived from a factor measured on a neutral base — e.g.
  `editorIndentGuide.background*` (`#3B4352`), `editor.selectionHighlightBackground` (`#424450`).
  Left as authored.
- **Legacy themes:** their own older design; the same syntax and selection/foreground corrections were
  applied, but their surface palette does not follow the Modern presets.

---

## 6. Recipe for creating a new theme

1. Take the preset's `base_color` and `accent_color` from step 2 (or define your own).
2. **If the accent matches an existing theme** (like Gray↔Godot 3): copy that `.json` and only
   recompute the `base·factor` surfaces (section 4) for the new base. That is how `gray` was made:
   starting from `godot-theme-vscode-godot-3.json` and neutralizing the surfaces.
3. **If the accent is new:** also replace the accent-derived values:
   `selection = accent·α0.4` (`…66`), `highlight = accent·α0.275` (`…46`), and the opaque accent on borders/badges.
4. Keep the syntax (`tokenColors`/`semanticTokenColors`) identical unless you want the Godot 2 palette.
5. Register the theme in [package.json](package.json) → `contributes.themes` (`label`, `uiTheme: vs-dark`, `path`).
6. Update the non-standard `"godot-theme-vscode"` block at the top of the `.json` so the palette stays self-documenting.
7. Visual QA: activate the theme and reload [tests/test.gd](tests/test.gd) and [tests/test.cs](tests/test.cs).
