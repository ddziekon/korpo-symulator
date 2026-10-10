class_name Player
extends CharacterBody2D
## Gracz. Tylko łączy komponenty ze sobą: ruch to MovementComponent, animacja to DirectionalAnimator.

@export var movement: MovementComponent
@export var interaction_point: Marker2D
## Odległość punktu interakcji od środka ciała postaci (w pikselach).
@export_range(0.0, 64.0, 1.0) var interaction_distance: float = 12.0
## Środek ciała względem pozycji węzła (pozycja węzła to stopy, potrzebne do Y-sortu).
@export var body_center: Vector2 = Vector2(0.0, -8.0)


func _ready() -> void:
	assert(movement != null, "Player: brak przypisanego 'movement' w Inspektorze.")
	movement.direction_changed.connect(_on_direction_changed)
	_on_direction_changed(movement.facing_direction)


func _on_direction_changed(direction: Vector2) -> void:
	if interaction_point != null:
		interaction_point.position = body_center + direction * interaction_distance
