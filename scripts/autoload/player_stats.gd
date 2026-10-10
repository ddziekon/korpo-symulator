extends Node
## Globalny stan bohatera (autoload "PlayerStats"): zdrowie, energia i pieniądze.
## Żyje poza scenami, więc przetrwa zmianę pokoju.

signal money_changed(amount: int)

@export var health: StatComponent
@export var energy: StatComponent
@export var start_money: int = 0

var money: int = 0


func _ready() -> void:
	assert(health != null, "PlayerStats: brak 'health'.")
	assert(energy != null, "PlayerStats: brak 'energy'.")
	money = start_money


## Dodaje pieniądze (kwota dodatnia).
func add_money(amount: int) -> void:
	if amount <= 0:
		return
	money += amount
	money_changed.emit(money)


## Wydaje pieniądze. Zwraca false, gdy nie stać gracza (nic się wtedy nie zmienia).
func spend_money(amount: int) -> bool:
	if amount < 0 or amount > money:
		return false
	money -= amount
	money_changed.emit(money)
	return true


## Przywraca stan początkowy, np. przy "Nowej grze".
func reset() -> void:
	health.reset()
	energy.reset()
	money = start_money
	money_changed.emit(money)
