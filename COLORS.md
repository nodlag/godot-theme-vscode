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
| **Light** ☀ | `Color(0.9,0.9,0.9)` = `#e6e6e6` | `Color(0.18,0.50,1.0)` = `#2e80ff` | −0.06 |
| **Solarized (Dark)** | `Color(0.03,0.21,0.26)` = `#083642` | `Color(0.15,0.55,0.82)` = `#268cd1` | 0.23 |
| **Solarized (Light)** ☀ | `Color(0.89,0.86,0.79)` = `#e3dbc9` | `Color(0.15,0.55,0.82)` = `#268cd1` | −0.06 |
| Black (OLED) | `#000000` | `#73bfff` | 0.0 |

> Gray shares its `accent_color` with Godot 3; only the `base_color` changes (neutral gray).
> Solarized (Dark) and Solarized (Light) share their `accent_color`; only `base_color`/`contrast` differ.
> **Theme polarity** is decided by `base_color.get_luminance() < 0.5` (`is_dark_theme`,
> `editor_theme_manager.cpp:734`). ☀ marks the **light** themes (luminance ≥ 0.5): they flip
> `mono_color` to black, use `font_color = #000000bf`, the light syntax branch (§3), and an inverted
> UI elevation (§4). All presets above except the two ☀ and Black (OLED) are dark. Eight of these
> presets ship as Modern themes (`contributes.themes`): the five dark + `Light`, `Solarized (Dark)`,
> `Solarized (Light)`. Light themes are registered with `uiTheme: "vs"`, dark with `"vs-dark"`.

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

### Light themes syntax (Godot **light** branch)

Light themes (`Light`, `Solarized (Light)`) use Godot's `: else` branch of the syntax ternaries
(`editor_theme_manager.cpp:497-560`, taken when `dark_icon_and_font` is false). Exact Godot light hex:

| Role | Godot light `Color(...)` | hex | Role | Godot light `Color(...)` | hex |
|---|---|---|---|---|---|
| symbol | `(0,0,0.61)` | `#00009c` | string | `(0.6,0.42,0)` | `#996b00` |
| keyword | `(0.9,0.135,0.51)` | `#e62282` | string_placeholder | `(0.93,0.6,0.33)` | `#ed9954` |
| control_flow | `(0.743,0.12,0.8)` | `#be1fcc` | number | `(0,0.55,0.28)` | `#008c47` |
| base_type | `(0,0.6,0.2)` | `#009933` | function | `(0,0.225,0.9)` | `#0039e6` |
| engine_type | `(0.11,0.55,0.4)` | `#1c8c66` | member_variable | `(0,0.4,0.68)` | `#0066ad` |
| user_type | `(0.18,0.45,0.4)` | `#2e7366` | annotation | `(0.8,0.37,0)` | `#cc5e00` |
| comment | `(0.08,0.08,0.08,0.5)` | `#14141480` | node_reference | `(0,0.5,0)` | `#008000` |
| doc_comment | `(0.15,0.15,0.4,0.7)` | `#262666b3` | node_path | `(0.18,0.55,0)` | `#2e8c00` |

> The shipped light themes derive **mono/white-alpha** colors by simple inversion
> (`#ffffffXX` → `#000000XX`), so e.g. the editor `comment` renders as `#00000080` — visually
> identical to Godot's exact light `comment` `#14141480`. Non-Godot author scopes (prose markdown,
> macros) are darkened to remain legible on the light background.

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
| editor background | `base.lerp(black, contrast·1.2)` dark · `contrast·1.8` light | `editor.background`, `terminal.background`, `panel.background`, `peekViewEditor.background` |
| `font_color` | `mono_font · 0.75` — dark `#ffffffbf`, light `#000000bf` | `editor.foreground`, `foreground`, and every text `*.foreground` |
| `selection_color` | `accent · α0.4` | `editor.selectionBackground`, `selection.background` |
| `highlight_color` | `accent · α0.275` | `list.activeSelectionBackground`, `list.focusBackground` |
| accent (opaque) | (input) | `*.activeBorder`, `activityBarBadge`, `statusBar.debuggingBackground`, `pickerGroup`, `inputOption.activeBorder` |
| `current_line` / word highlight | `mono · α0.07` — dark `#ffffff12`, light `#00000012` | `editor.lineHighlightBackground`, `editor.wordHighlightBackground`, `editor.hoverHighlightBackground` |
| `dark_color_1` | `base.lerp(black, 0.345)` | (Godot-internal; not mapped 1:1) |
| `dark_color_3` | `base` with value `·(1−0.24)` | (Godot-internal) |
| `contrast_color_1` | `base.lerp(white, 0.345)` | light borders |
| `contrast_color_2` | `base.lerp(white, 0.5175)` | strong light borders |
| `success` / `warning` / `error` (dark) | `#73f280` / `#d4c79e` / `#ff786b` | `editorError/Warning`, gitDecoration |

### Workbench surfaces — Godot's HSV elevation (`_get_base_color`)

VS Code has more surfaces (activityBar, titleBar, scrollbar, tabs, dropdowns…) than Godot themes
*by name*, but they are **not** arbitrary: they reproduce Godot's surface-elevation helper
`_get_base_color(base, dim_ofs, sat_mult)` (`theme_modern.cpp:45`):

```
final_contrast = (dim_ofs < 0) ? clamp(contrast, -0.1, 0.5) : contrast
v' = clamp( lerp(base.value, 0, final_contrast · dim_ofs), 0, 1 )   // HSV value
s' = base.saturation · sat_mult
surface = hsv(base.hue, s', v')
```

This is HSV (it scales **value** and **saturation**), which is why it preserves hue on tinted bases
and **auto-inverts on light themes** (negative contrast lerps *away* from black → recessed surfaces
lighten toward white). The shade groups map to these `(dim_ofs, sat_mult)` pairs — verified to
reproduce the neutral **Default** theme exactly:

| Shade | `(dim, sat)` | Default | usage |
|---|---|---|---|
| darkest | `(1.7, 0.9)` | `#141414` | scrollbar.shadow, activityBar/titleBar/commandCenter/dropdown bg, tab.border/inactive, panel.border |
| input | `(1.1, 0.9)` | `#1c1c1c` | input.background |
| border | `(0.8, 1.0)` | `#1f1f1f` | input.border, editorGroup.border, peekViewTitle, settings borders |
| **base** | `(0, 1.0)` | `#292929` | sideBar/statusBar/widgets |
| section | `(-1.3, 0.8)` | `#393939` | sideBarSectionHeader.background |
| button | `(-2.0, 0.85)` | `#424242` | button.background |

> On **neutral** bases (Default, Gray) HSV is identical to the older "× factor" approximation
> (darkest ≈ ×0.488, input ×0.683, border ×0.756, section ×1.39, button ×1.61), because a grey base
> has zero saturation. On **tinted** bases the two diverge by ≤7/255; the HSV formula above is the
> Godot-true one and is what every theme now uses.
> **`editor.findRangeHighlightBackground`** (Default `#555555`) is the one surface with **no** clean
> Godot mapping — it is an author pick (~`base·2.07` on neutral bases) kept consistent family-wide,
> not HSV-derived.

---

## 5. Fidelity status (current audit)

- **Syntax:** 1:1 with Godot across all 8 Modern themes — the 6 dark themes use the dark palette,
  the 2 light themes (`Light`, `Solarized (Light)`) use the light palette (§3). The 2 Legacy themes
  share the dark syntax (see the Legacy bullet) — so all 10 themes match.
- **Editor (bg, fg, selection, current line, word highlight) and accent:** 1:1 across the 8 Modern themes.
- **Godot 3 `base_color` aligned to Godot 1:1:** `#363d4a` (`Color(0.21,0.24,0.29)`), which makes
  `editor.background` = `#22272f` (`base·0.64` from float, rounded once). Previously the author used
  `#373d49`/`#23272e`. The three `commandCenter.*Border` keys (top menu bar / project-name pill) also
  held a `#3d3b44` leftover — that is **Godot 2's** `base_color` — and were corrected to Godot 3's
  base `#363d4a` (matching how Default/Gray set the command-center border to their own base).
- **Godot 3 darkest workbench group** (titleBar, activityBar, commandCenter, dropdown,
  scrollbar.shadow, tabs, panel.border…): the previous hand-set `#1c1f24` raised R/G while keeping B,
  compressing the blue tint so the title bar looked grayer than the palette. Now `#1b1f24`
  (HSV-exact, see below).
- **Godot 3 `sideBarSectionHeader.background`** (the Explorer section header where the
  project/workspace name shows): the previous `#525966` had the same grayness issue. Now `#505967`
  (HSV-exact). The header text inherits `sideBar.foreground` `#ffffffbf` = font_color (already correct).
- **Breeze & Godot 2 `base_color` aligned to Godot 1:1:** Breeze `#202326` (`Color(0.1255,0.1373,0.149)`,
  was `#212326`); Godot 2 `#3d3b45` (`Color(0.24,0.23,0.27)`, was `#3d3b44`). Their `editor.background`
  (float `base·0.64`) was already exact.
- **Workbench surface groups corrected to Godot's HSV `_get_base_color` (§4)** for the 3 tinted
  themes (Breeze, Godot 2, Godot 3). They had been regenerated with an integer "× factor"
  approximation; on saturated bases that diverged from Godot's true HSV elevation by ≤7/255 (e.g.
  Godot 3 section `#4b5567` → `#505967`, button `#576277` → `#5b6576`, darkest `#1a1e24` → `#1b1f24`).
  The five HSV-genuine groups (darkest, input, border, section, button) are now HSV-exact; neutral
  Default/Gray were already exact (a grey base has zero saturation, so factor ≡ HSV).
  `editor.findRangeHighlightBackground` stays the lone author pick (§4 note).
- **Out of model (author choices, no Godot reference):** a few tinted one-off surfaces exist only in
  the tinted themes — e.g. `editorIndentGuide.background*` (`#3B4352`),
  `editor.selectionHighlightBackground` (`#424450`). Left as authored on the existing themes; the new
  themes (below) derive their equivalents from the HSV surfaces.
- **Top bar logic (consistent across all Modern dark themes):** `titleBar.*Background` and
  `commandCenter.background` belong to the `darkest` HSV group, one step darker than
  `editor.background`. Uniform family-wide; on near-black bases (Default) the step is imperceptible,
  on tinted bases (Godot 3) it is visible, but the rule is the same.
- **New Modern themes — derived 1:1 from Godot (`gen_themes.py` workflow):**
  `Light` (`#e6e6e6`/`#2e80ff`), `Solarized (Dark)` (`#083642`/`#268cd1`, contrast 0.23) and
  `Solarized (Light)` (`#e3dbc9`/`#268cd1`) were generated from the **Default** template by
  substituting each color by role (base, editor-bg, accent, selection/highlight, mono whites, the
  HSV surfaces, and the syntax palette). Solarized (Dark) reuses the dark syntax palette;
  the two **light** themes (`uiTheme: "vs"`) use the **light syntax branch** (§3), `font_color`
  `#000000bf`, mono-inverted whites, and the auto-inverted HSV elevation (recessed surfaces lighten
  toward white; `editor.background` = `base.lerp(black, contrast·1.8)` ≈ near-white). All three pass
  the editor/selection/syntax 1:1 checks; visual QA on the light themes still pending.
- **Legacy themes — syntax validated 1:1, UI intentionally unchanged:**
  `legacy-godot-theme-vscode.json` and `legacy-godot-theme-vscode-breeze-dark.json` share their presets
  with Modern **Godot 3** and **Breeze Dark** respectively. Their **syntax is byte-identical to the
  Modern themes** — 0 differences in `tokenColors` (93 entries) and `semanticTokenColors` (28 entries) —
  and therefore 1:1 with Godot: **105 / 121** colored entries match the exact Godot dark palette
  (section 3, `Math::round` half-away-from-zero); the remaining 5 are author colors for languages Godot
  does not highlight — Markdown/prose (`#f9eca8`, `#e9f284`), separators (`#79edff`), property quotes
  (`#8be9fe`) and macros/preprocessor (`#ad75c4`) — and are consistent across the dark themes
  (the 2 light themes darken these author scopes for legibility).
  `editor.foreground` (`#ffffffbf`) and `editor.lineHighlightBackground` (`#ffffff12`) also match.
  Their **UI surfaces deliberately preserve the older Godot 3.x-era layout** (the editor area is the
  darkest, panels step *up* in lightness) and are **not** regenerated to the Modern factor model:
  because the Legacy themes share presets with Modern, applying the current `godot-master` (Godot 4.x)
  formulas would make them byte-for-byte duplicates of Modern Godot 3 / Breeze Dark. Known surface
  deviations, left as authored by design (not bugs): Legacy G3 `editor.selectionBackground` =
  `#569eff66` (Default's accent rather than Godot 3's `#70bafa66`), and `editor.background`
  (`#16191f` / Breeze `#161718`) does not follow the float formula.

---

## 6. Recipe for creating a new theme

The reliable way (used for `Light` / `Solarized (Dark)` / `Solarized (Light)`): take the **Default**
template and substitute every color **by role** in a single pass. Steps:

1. Pick the preset's `base_color`, `accent_color`, `contrast` from §2 (or define your own). Decide
   polarity: **dark** if `base` luminance < 0.5, else **light**.
2. **Surfaces:** recompute each shade group with Godot's HSV `_get_base_color(base, dim, sat)` (§4).
   This works for any base and auto-inverts for light themes — no separate light logic needed.
   `editor.background = base.lerp(black, contrast · (dark ? 1.2 : 1.8))`.
3. **Accent-derived:** `selection = accent·α0.4` (`…66`), `highlight = accent·α0.275` (`…46`), and the
   opaque accent on borders/badges/active states.
4. **Mono/text:** dark → keep white-alpha (`font_color #ffffffbf`); **light → invert** every
   `#ffffffXX` to `#000000XX` (`font_color #000000bf`).
5. **Syntax:** dark themes keep the Default dark palette; **light themes swap in the light palette**
   (§3). (Use the Godot 2 palette only if you specifically want it.)
6. Register in [package.json](package.json) → `contributes.themes` with the correct `uiTheme`:
   **`"vs-dark"` for dark, `"vs"` for light**, plus `label` and `path`.
7. Update the non-standard `"godot-theme-vscode"` block at the top of the `.json` (it uses the same
   hexes, so a by-value substitution updates it automatically) so the palette stays self-documenting.
8. Visual QA: activate the theme and reload [tests/test.gd](tests/test.gd) and [tests/test.cs](tests/test.cs).
