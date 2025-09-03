class_name Config extends Node

## Placeholder for no window mode selection made.
const WINDOW_MODE_NONE: int = -1

## Location of the user-defined JSON configuration.
## In Windows this should resolve to something like: %appdata%\Godot\app_userdata\Desk Lamp\settings.json
const CONFIG_DIRECTORY: String = "user://"
const CONFIG_FILE: String = "settings.json"

## The default configuration when not overridden by user settings.
static var settings: Dictionary[String, Variant] = {
	"on_colors": [
		"#ffffff",   # Pure white (neutral task light)
		"#f5f5dc",   # Warm beige / soft cream
		"#fff8e7",   # Warm white (incandescent-like)
		"#fdfd96",   # Soft yellow (sunlight glow)
		"#ffd580",   # Warm amber (cozy lamp)
		"#c0fefc",   # Cool aqua-white (refreshing daylight)
		"#add8e6",   # Light blue (calm, soft ambience)
		"#e6e6fa",   # Lavender (relaxing, low-intensity mood)
		"#ffe4e1",   # Soft pink (gentle accent)
		"#d3d3d3"    # Light gray (dim lamp / low brightness mode)
	],
	"off_colors": [
		"black",
		"black",
		"black",
		"black",
		"black",
		"black",
		"black",
		"black",
		"black",
		"black"
	],
	"color_selection_number": 0,
	"brightness_step_amount": 0.05,
	"brightness": 1.0,
	"enabled": true,
}

## Load the user JSON configuration.
static func load_user_configuration() -> void:
	var config_path := CONFIG_DIRECTORY + CONFIG_FILE
	if not FileAccess.file_exists(config_path):
		return

	var file := FileAccess.open(config_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open settings.json")
		return

	var text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var err := json.parse(text)
	if err != OK:
		push_warning("settings.json is invalid JSON (error %s)" % err)
		return

	var data: Variant = json.data
	if typeof(data) == TYPE_DICTIONARY:
		for key in data.keys():
			settings[key] = data[key]

static func get_enabled() -> bool:
	return settings.get("enabled", false)

static func set_enabled(value: bool) -> void:
	settings["enabled"] = value

## Get the current palette selection.
static func get_color_selection_number() -> int:
	return int(settings.get("color_selection_number", 0))

## Get the configured "on" color for current palette selection.
static func get_on_color() -> Color:
	var index: int = get_color_selection_number()
	var colors: Variant = settings.get("on_colors", [])

	if colors is not Array:
		return Color.WHITE

	if colors.size() <= index:
		return Color.WHITE

	return Color.from_string(colors[index], Color.WHITE)

## Get the configured "off" color for current palette selection.
static func get_off_color() -> Color:
	var index: int = get_color_selection_number()
	var colors: Variant = settings.get("off_colors", [])
	if colors is not Array:
		return Color.BLACK

	if colors.size() <= index:
		return Color.BLACK

	return Color.from_string(colors[index], Color.BLACK)

## Get the configured default brightness.
static func get_brightness() -> float:
	return settings.get("brightness", 1.0)

## Set configured brightness.
static func set_brightness(amount: float) -> void:
	settings["brightness"] = round_to_decimals(amount, 3)

## Helper func for math precision.
static func round_to_decimals(value: float, decimals: int) -> float:
	var factor := pow(10.0, decimals)
	return round(value * factor) / factor

## Get the configured brightness step amount.
static func get_brightness_step_amount() -> float:
	return settings.get("brightness_step_amount", 0.05)

## Set the color palette to specific index.
static func set_color_selection(value: int) -> void:
	if value < get_max_colors_configured():
		settings["color_selection_number"] = value

## Select the next color palette.
static func next_color() -> void:
	settings["color_selection_number"] = get_color_selection_number() + 1
	# Wrap around to first configured color.
	if settings["color_selection_number"] >= get_max_colors_configured():
		settings["color_selection_number"] = 0

## Select the previous color palette.
static func previous_color() -> void:
	settings["color_selection_number"] = get_color_selection_number() - 1
	# Wrap around to last configured color.
	if settings["color_selection_number"] < 0:
		settings["color_selection_number"] = get_max_colors_configured() - 1

## Calculate and return whichever color array is the largest.
## This determines the maximum number of color palette selections to cycle through.
static func get_max_colors_configured() -> int:
	var on_colors = settings.get("on_colors", [])
	var off_colors = settings.get("off_colors", [])
	var total_on_colors: int = 0
	var total_off_colors: int = 0

	if on_colors is Array:
		total_on_colors = on_colors.size()

	if off_colors is Array:
		total_off_colors = off_colors.size()

	if total_on_colors > total_off_colors:
		return total_on_colors

	return total_off_colors

## Open the configuration directory in OS file explorer.
static func open_configuration_directory() -> void:
	var dir_path := ProjectSettings.globalize_path(CONFIG_DIRECTORY)
	OS.shell_open(dir_path)

## Save user configuration.
static func save_user_configuration(overwrite_if_exists: bool = true) -> void:
	var config_path := CONFIG_DIRECTORY + CONFIG_FILE

	if not overwrite_if_exists:
		if FileAccess.file_exists(config_path):
			return

	var file := FileAccess.open(config_path, FileAccess.WRITE)
	if file == null:
		push_warning("Failed to open settings.json for writing")
		return

	var json_text := JSON.stringify(settings, "\t")
	file.store_string(json_text)
	file.close()
