class_name MovementComponent
extends Node
## Komponent ruchu w 8 kierunkach. Steruje wskazanym CharacterBody2D.

## Emitowany, gdy zmieni się kierunek, w którym patrzy postać.
signal direction_changed(direction: Vector2)
signal movement_started
signal movement_stopped

## Ciało, które komponent porusza (ustawiane w Inspektorze).
@export var body: CharacterBody2D
## Maksymalna prędkość w pikselach na sekundę.
@export_range(1.0, 500.0, 1.0) var max_speed: float = 90.0
## Jak szybko postać nabiera prędkości (piksele/s²).
@export_range(1.0, 5000.0, 1.0) var acceleration: float = 800.0
## Jak szybko postać hamuje po puszczeniu klawiszy (piksele/s²).
@export_range(1.0, 5000.0, 1.0) var friction: float = 1000.0

var facing_direction: Vector2 = Vector2.DOWN
var _is_moving: bool = false


func _ready() -> void:
	assert(body != null, "MovementComponent: brak przypisanego 'body' w Inspektorze.")


func _physics_process(delta: float) -> void:
	if body == null:
		return

	# get_vector zwraca wektor o długości max 1, więc ruch po skosie nie jest szybszy.
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_direction != Vector2.ZERO:
		body.velocity = body.velocity.move_toward(input_direction * max_speed, acceleration * delta)
		_update_facing(input_direction.normalized())
	else:
		body.velocity = body.velocity.move_toward(Vector2.ZERO, friction * delta)

	body.move_and_slide()
	_update_moving_state()


func _update_facing(new_direction: Vector2) -> void:
	if new_direction.is_equal_approx(facing_direction):
		return
	facing_direction = new_direction
	direction_changed.emit(facing_direction)


func _update_moving_state() -> void:
	var moving_now: bool = not body.velocity.is_zero_approx()
	if moving_now == _is_moving:
		return
	_is_moving = moving_now
	if _is_moving:
		movement_started.emit()
	else:
		movement_stopped.emit()
