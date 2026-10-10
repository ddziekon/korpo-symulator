class_name IntroCutscene
extends Node
## Scena wprowadzająca: sen, budzenie, przemiana w postać z gry, przejście do pokoju.
## Kolejnością i czasem steruje AnimationPlayer (Sequencer), który wywołuje metody tej klasy.

signal intro_finished

@export var next_scene: PackedScene
@export var sequencer: AnimationPlayer
@export var sleeping_boy: AnimatedSprite2D
@export var game_boy: Sprite2D
@export var zzz_spawner: ZzzSpawner
@export var skip_enabled: bool = true

var _finished: bool = false


func _ready() -> void:
	assert(sequencer != null, "IntroCutscene: brak 'sequencer'.")
	assert(sleeping_boy != null, "IntroCutscene: brak 'sleeping_boy'.")
	assert(game_boy != null, "IntroCutscene: brak 'game_boy'.")
	assert(zzz_spawner != null, "IntroCutscene: brak 'zzz_spawner'.")
	game_boy.visible = false
	sleeping_boy.play("sleep")
	sequencer.animation_finished.connect(_on_sequencer_finished)
	sequencer.play("intro")


func _unhandled_input(event: InputEvent) -> void:
	if not skip_enabled or _finished:
		return
	var is_key_or_button: bool = event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton
	if is_key_or_button and event.is_pressed() and not event.is_echo():
		finish()


## Wywoływane przez Sequencer.
func start_zzz() -> void:
	zzz_spawner.start()


func stop_zzz() -> void:
	zzz_spawner.stop()


func wake_up() -> void:
	sleeping_boy.play("wake_up")


## Wywoływane w najjaśniejszym momencie błysku.
func swap_to_hero() -> void:
	sleeping_boy.visible = false
	game_boy.visible = true


func finish() -> void:
	if _finished:
		return
	_finished = true
	sequencer.stop()
	zzz_spawner.stop()
	intro_finished.emit()
	if next_scene != null:
		get_tree().change_scene_to_packed(next_scene)


func _on_sequencer_finished(_animation_name: StringName) -> void:
	finish()
