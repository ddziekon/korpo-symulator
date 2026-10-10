class_name FollowCamera
extends Camera2D
## Kamera podążająca za rodzicem, z wygładzaniem i opcjonalnymi granicami świata.

@export var smoothing_enabled: bool = true
@export_range(1.0, 30.0, 0.5) var smoothing_speed: float = 8.0
## Czy ograniczać kamerę do prostokąta świata (w pikselach).
@export var use_world_bounds: bool = false
@export var world_bounds: Rect2i = Rect2i(0, 0, 0, 0)


func _ready() -> void:
	position_smoothing_enabled = smoothing_enabled
	position_smoothing_speed = smoothing_speed
	if use_world_bounds:
		apply_world_bounds(world_bounds)


## Ustawia granice kamery, np. po wczytaniu nowego poziomu.
func apply_world_bounds(bounds: Rect2i) -> void:
	limit_left = bounds.position.x
	limit_top = bounds.position.y
	limit_right = bounds.end.x
	limit_bottom = bounds.end.y
