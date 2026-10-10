class_name Hud
extends CanvasLayer
## Interfejs podczas gry: paski zdrowia i energii oraz licznik pieniędzy. Dane bierze z autoloadu PlayerStats.

@export var health_bar: StatBar
@export var energy_bar: StatBar
@export var money_label: Label
@export_range(0.05, 1.0, 0.05) var money_flash_time: float = 0.3

var _money_tween: Tween


func _ready() -> void:
	assert(health_bar != null, "Hud: brak 'health_bar'.")
	assert(energy_bar != null, "Hud: brak 'energy_bar'.")
	assert(money_label != null, "Hud: brak 'money_label'.")
	health_bar.bind(PlayerStats.health)
	energy_bar.bind(PlayerStats.energy)
	PlayerStats.money_changed.connect(_on_money_changed)
	_show_money(PlayerStats.money)


func _on_money_changed(amount: int) -> void:
	_show_money(amount)
	# Krótki błysk licznika, żeby zmiana rzucała się w oczy.
	if _money_tween != null:
		_money_tween.kill()
	money_label.modulate = Color(1, 1, 0.6, 1)
	_money_tween = create_tween()
	_money_tween.tween_property(money_label, "modulate", Color.WHITE, money_flash_time)


func _show_money(amount: int) -> void:
	money_label.text = _format_money(amount)


## Zapis z odstępem tysięcy, np. 12500 -> "12 500 zł".
func _format_money(amount: int) -> String:
	var digits: String = str(absi(amount))
	var grouped: String = ""
	for i: int in digits.length():
		if i > 0 and (digits.length() - i) % 3 == 0:
			grouped += " "
		grouped += digits[i]
	return ("-" if amount < 0 else "") + grouped + " zł"
