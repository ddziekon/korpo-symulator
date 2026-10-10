class_name StatComponent
extends Node
## Uniwersalna statystyka z zakresem 0..max (zdrowie, energia itd.). Nic nie wie o tym, do kogo należy.

## Emitowany po każdej zmianie wartości lub maksimum.
signal changed(current: int, maximum: int)
## Emitowany, gdy wartość spadnie do zera.
signal depleted

@export_range(1, 1000, 1) var max_value: int = 100
## Wartość początkowa. Wartość ujemna oznacza "start od maksimum".
@export var start_value: int = -1

var current: int = 0


func _ready() -> void:
	reset()


## Zmienia wartość o podaną ilość (ujemna odejmuje) i zwraca faktyczną zmianę po przycięciu do zakresu.
func change(amount: int) -> int:
	var previous: int = current
	current = clampi(current + amount, 0, max_value)
	if current != previous:
		changed.emit(current, max_value)
		if current == 0:
			depleted.emit()
	return current - previous


func reset() -> void:
	current = max_value if start_value < 0 else clampi(start_value, 0, max_value)
	changed.emit(current, max_value)


func get_ratio() -> float:
	return float(current) / float(max_value)


func is_empty() -> bool:
	return current == 0
