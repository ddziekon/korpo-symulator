class_name StatsDebugKeys
extends Node
## Tylko do testów (usuwa się sam w wersji release): klawisze zmieniają statystyki, żeby było widać reakcję HUD.
## F1 = -10 zdrowia, F2 = -10 energii, F3 = +250 zł, F4 = reset.


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()


func _unhandled_key_input(event: InputEvent) -> void:
	var key_event: InputEventKey = event as InputEventKey
	if key_event == null or not key_event.pressed or key_event.echo:
		return
	match key_event.keycode:
		KEY_F1:
			PlayerStats.health.change(-10)
		KEY_F2:
			PlayerStats.energy.change(-10)
		KEY_F3:
			PlayerStats.add_money(250)
		KEY_F4:
			PlayerStats.reset()
