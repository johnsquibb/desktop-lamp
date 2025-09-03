class_name Desktop extends Control

@onready var lamp: ColorRect = $Lamp
@onready var background: ColorRect = $Background
@onready var power_label: Label = %PowerLabel
@onready var help_container: CenterContainer = %HelpContainer
@onready var instructions_label: Label = %InstructionsLabel
@onready var brightness_label: Label = %BrightnessLabel
@onready var color_selection_label: Label = %ColorSelectionLabel
@onready var dim_override_labels: Array[Label] = [
	%DisableLabel,
	%BrightnessLabel,
	%BrightnessAdjustLabel,
	%ColorSelectionLabel,
	%ColorAdjustLabel,
	%InstructionsLabel,
]

## Remember the previous window mode so it can be restored when toggling fullscreen.
var previous_window_mode: int = -1

func _init() -> void:
	Config.save_user_configuration(false) # Create configuration if it does not exist
	Config.load_user_configuration()

func _ready() -> void:
	apply_configuration()

func apply_configuration() -> void:
	Config.save_user_configuration()
	update_lamp()
	update_power_label()
	update_background()
	update_color_selection()
	update_instructions()
	update_brightness()

func update_color_selection() -> void:
	color_selection_label.text = "Color Selection: %d" % Config.get_color_selection_number()

func update_background() -> void:
	background.color = Config.get_off_color()

func update_power_label() -> void:
	power_label.visible = !lamp.visible
	power_label.add_theme_color_override("font_color", Config.get_on_color())

func update_lamp() -> void:
	lamp.visible = Config.get_enabled()
	lamp.self_modulate.a = Config.get_brightness()
	lamp.color = Config.get_on_color()

func update_brightness() -> void:
	brightness_label.text = "Brightness %d%%" % [
		round(lamp.self_modulate.a * 100)
	]

func update_instructions() -> void:
	# Swap the instructions' font color for readability at specific brightness levels.
	if lamp.self_modulate.a <= 0.25:
		for label: Label in dim_override_labels:
			label.add_theme_color_override("font_color", Config.get_on_color())

	if lamp.self_modulate.a >= 0.50:
		for label: Label in dim_override_labels:
			label.add_theme_color_override("font_color", Config.get_off_color())

func toggle_fullscreen() -> void:
	if previous_window_mode != Config.WINDOW_MODE_NONE:
		DisplayServer.window_set_mode(previous_window_mode as DisplayServer.WindowMode)
		previous_window_mode = Config.WINDOW_MODE_NONE
		return

	previous_window_mode = DisplayServer.window_get_mode()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func dim() -> void:
	var brightness: float = clamp(lamp.self_modulate.a - Config.get_brightness_step_amount(), 0.0, 1.0)
	Config.set_brightness(brightness)

func brighten() -> void:
	var brightness: float = clamp(lamp.self_modulate.a + Config.get_brightness_step_amount(), 0.0, 1.0)
	Config.set_brightness(brightness)

func hide_instructions() -> void:
	power_label.hide()
	help_container.hide()

func show_instructions() -> void:
	help_container.show()
	power_label.visible = !lamp.visible

func _on_lamp_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("touch"):
		Config.set_enabled(!lamp.visible)
		apply_configuration()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		toggle_fullscreen()

	if event.is_action_pressed("quit"):
		get_tree().quit()

	if event.is_action_pressed("open_config_directory"):
		Config.open_configuration_directory()

	if event.is_action_pressed("previous_color"):
		Config.previous_color()
		apply_configuration()

	if event.is_action_pressed("next_color"):
		Config.next_color()
		apply_configuration()

	if event.is_action_pressed("color_0"):
		Config.set_color_selection(0)
		apply_configuration()

	if event.is_action_pressed("color_1"):
		Config.set_color_selection(1)
		apply_configuration()

	if event.is_action_pressed("color_2"):
		Config.set_color_selection(2)
		apply_configuration()

	if event.is_action_pressed("color_3"):
		Config.set_color_selection(3)
		apply_configuration()

	if event.is_action_pressed("color_4"):
		Config.set_color_selection(4)
		apply_configuration()

	if event.is_action_pressed("color_5"):
		Config.set_color_selection(5)
		apply_configuration()

	if event.is_action_pressed("color_6"):
		Config.set_color_selection(6)
		apply_configuration()

	if event.is_action_pressed("color_7"):
		Config.set_color_selection(7)
		apply_configuration()

	if event.is_action_pressed("color_8"):
		Config.set_color_selection(8)
		apply_configuration()

	if event.is_action_pressed("color_9"):
		Config.set_color_selection(9)
		apply_configuration()

	# Hold down action to rapidly dim.
	if Input.is_action_pressed("dim"):
		if lamp.visible:
			dim()
			apply_configuration()

	# Hold down action to rapidly brighten.
	if Input.is_action_pressed("brighten"):
		if lamp.visible:
			brighten()
			apply_configuration()

func _on_mouse_exited() -> void:
	hide_instructions()

func _on_mouse_entered() -> void:
	show_instructions()
