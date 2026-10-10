class_name MainMenu
extends Control
## Menu główne: "Nowa gra" uruchamia intro, "Kontynuuj" czeka na system zapisu, "Wyjdź" zamyka grę.

signal new_game_started

@export var intro_scene: PackedScene
@export var new_game_button: Button
@export var continue_button: Button
@export var quit_button: Button
@export var version_label: Label
@export var scene_fader: ColorRect
@export_range(0.1, 3.0, 0.1) var fade_duration: float = 0.8

var _is_transitioning: bool = false


func _ready() -> void:
	assert(intro_scene != null, "MainMenu: brak 'intro_scene'.")
	assert(new_game_button != null, "MainMenu: brak 'new_game_button'.")
	assert(continue_button != null, "MainMenu: brak 'continue_button'.")
	assert(quit_button != null, "MainMenu: brak 'quit_button'.")
	assert(scene_fader != null, "MainMenu: brak 'scene_fader'.")

	new_game_button.pressed.connect(_on_new_game_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	# Zapisu gry jeszcze nie ma, więc "Kontynuuj" jest nieaktywne i nie może łapać fokusu z klawiatury.
	continue_button.disabled = true
	continue_button.focus_mode = Control.FOCUS_NONE

	if version_label != null:
		var version: String = str(ProjectSettings.get_setting("application/config/version", "0.0.0"))
		version_label.text = "v" + version

	# Fokus na pierwszym przycisku, żeby menu działało z klawiatury i pada.
	new_game_button.grab_focus()
	_fade_to(0.0)


func _on_new_game_pressed() -> void:
	if _is_transitioning:
		return
	_is_transitioning = true
	new_game_button.disabled = true
	quit_button.disabled = true
	# Nowa gra zawsze startuje z pełnymi statystykami i zerem pieniędzy.
	PlayerStats.reset()
	new_game_started.emit()
	var fade: Tween = _fade_to(1.0)
	await fade.finished
	get_tree().change_scene_to_packed(intro_scene)


func _on_quit_pressed() -> void:
	if _is_transitioning:
		return
	get_tree().quit()


func _fade_to(target_alpha: float) -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(scene_fader, "modulate:a", target_alpha, fade_duration)
	return tween
