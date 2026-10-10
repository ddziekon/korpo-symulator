class_name Player
extends CharacterBody2D
## Gracz. Tylko łączy komponenty ze sobą, logika ruchu jest w MovementComponent.

## Rozmiar kafelka i krok w arkuszu (16 px + 1 px odstępu).
const CELL_SIZE: int = 16
const CELL_STEP: int = 17
## Kolumny arkusza dla kierunków: lewo, dół (przodem), góra (tyłem), prawo.
const COLUMN_LEFT: int = 23
const COLUMN_DOWN: int = 24
const COLUMN_UP: int = 25
const COLUMN_RIGHT: int = 26

@export var movement: MovementComponent
@export var sprite: Sprite2D
@export var interaction_point: Marker2D
## Wiersz postaci w arkuszu (0 = chłopak w zielonej koszulce, stojący).
@export var sprite_row: int = 0
## Odległość punktu interakcji od środka ciała postaci (w pikselach).
@export_range(0.0, 64.0, 1.0) var interaction_distance: float = 12.0
## Środek ciała względem pozycji węzła (pozycja węzła to stopy, potrzebne do Y-sortu).
@export var body_center: Vector2 = Vector2(0.0, -6.0)


func _ready() -> void:
	assert(movement != null, "Player: brak przypisanego 'movement' w Inspektorze.")
	movement.direction_changed.connect(_on_direction_changed)
	_on_direction_changed(movement.facing_direction)


func _on_direction_changed(direction: Vector2) -> void:
	if interaction_point != null:
		interaction_point.position = body_center + direction * interaction_distance
	if sprite != null:
		_set_sprite_column(_column_for_direction(direction))


func _column_for_direction(direction: Vector2) -> int:
	# Przy ruchu po skosie wygrywa oś o większej wartości.
	if absf(direction.x) > absf(direction.y):
		return COLUMN_RIGHT if direction.x > 0.0 else COLUMN_LEFT
	return COLUMN_DOWN if direction.y > 0.0 else COLUMN_UP


func _set_sprite_column(column: int) -> void:
	sprite.region_rect = Rect2(
		Vector2(column * CELL_STEP, sprite_row * CELL_STEP),
		Vector2(CELL_SIZE, CELL_SIZE)
	)
