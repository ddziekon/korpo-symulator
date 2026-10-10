class_name DirectionalAnimator
extends Node
## Animuje postać w 4 kierunkach. Słucha sygnałów MovementComponent: przełącza bezczynność i bieg.

## Kolejność kierunków w arkuszach Modern Interiors: prawo, góra, lewo, dół.
const DIRECTION_RIGHT: int = 0
const DIRECTION_UP: int = 1
const DIRECTION_LEFT: int = 2
const DIRECTION_DOWN: int = 3

@export var movement: MovementComponent
@export var sprite: Sprite2D
@export var idle_texture: Texture2D
@export var run_texture: Texture2D
## Liczba klatek jednego kierunku w arkuszu.
@export_range(1, 24, 1) var frames_per_direction: int = 6
@export_range(1.0, 30.0, 0.5) var idle_fps: float = 5.0
@export_range(1.0, 30.0, 0.5) var run_fps: float = 10.0

var _direction_index: int = DIRECTION_DOWN
var _is_running: bool = false
var _elapsed: float = 0.0


func _ready() -> void:
	assert(movement != null, "DirectionalAnimator: brak przypisanego 'movement'.")
	assert(sprite != null, "DirectionalAnimator: brak przypisanego 'sprite'.")
	movement.direction_changed.connect(_on_direction_changed)
	movement.movement_started.connect(_on_movement_started)
	movement.movement_stopped.connect(_on_movement_stopped)
	_direction_index = _index_for_direction(movement.facing_direction)
	_apply_texture()


func _process(delta: float) -> void:
	_elapsed += delta
	_update_frame()


func _on_direction_changed(direction: Vector2) -> void:
	_direction_index = _index_for_direction(direction)
	_update_frame()


func _on_movement_started() -> void:
	_is_running = true
	_elapsed = 0.0
	_apply_texture()


func _on_movement_stopped() -> void:
	_is_running = false
	_elapsed = 0.0
	_apply_texture()


func _apply_texture() -> void:
	sprite.texture = run_texture if _is_running else idle_texture
	sprite.hframes = frames_per_direction * 4
	_update_frame()


func _update_frame() -> void:
	var fps: float = run_fps if _is_running else idle_fps
	var step: int = int(_elapsed * fps) % frames_per_direction
	sprite.frame = _direction_index * frames_per_direction + step


func _index_for_direction(direction: Vector2) -> int:
	# Przy ruchu po skosie wygrywa oś o większej wartości.
	if absf(direction.x) > absf(direction.y):
		return DIRECTION_RIGHT if direction.x > 0.0 else DIRECTION_LEFT
	return DIRECTION_DOWN if direction.y > 0.0 else DIRECTION_UP
