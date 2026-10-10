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


## Ustawia granice kamery. Jeśli świat jest mniejszy niż ekran, kamera zostaje wyśrodkowana na nim.
@warning_ignore("integer_division")
func apply_world_bounds(bounds: Rect2i) -> void:
	var view_size: Vector2i = Vector2i(get_viewport_rect().size)
	var extra_x: int = maxi(view_size.x - bounds.size.x, 0)
	var extra_y: int = maxi(view_size.y - bounds.size.y, 0)
	limit_left = bounds.position.x - extra_x / 2
	limit_top = bounds.position.y - extra_y / 2
	limit_right = bounds.end.x + extra_x - extra_x / 2
	limit_bottom = bounds.end.y + extra_y - extra_y / 2
	reset_smoothing()
