class_name Player
extends CharacterBody2D
## Gracz. Tylko łączy komponenty ze sobą, logika ruchu jest w MovementComponent.

@export var movement: MovementComponent
@export var sprite: Sprite2D
@export var interaction_point: Marker2D
## Odległość punktu interakcji od środka postaci (w pikselach).
@export_range(0.0, 64.0, 1.0) var interaction_distance: float = 12.0


func _ready() -> void:
	assert(movement != null, "Player: brak przypisanego 'movement' w Inspektorze.")
	movement.direction_changed.connect(_on_direction_changed)
	_on_direction_changed(movement.facing_direction)


func _on_direction_changed(direction: Vector2) -> void:
	if interaction_point != null:
		interaction_point.position = direction * interaction_distance
	# Odbijamy sprite tylko przy ruchu poziomym, żeby nie migał przy ruchu góra/dół.
	if sprite != null and not is_zero_approx(direction.x):
		sprite.flip_h = direction.x < 0.0
