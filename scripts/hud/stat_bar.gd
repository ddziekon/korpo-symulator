class_name StatBar
extends HBoxContainer
## Wiersz HUD: ikona + pasek. Wartość pokazuje płynnie (tween), a przy niskim stanie zmienia kolor.

@export var bar: ProgressBar
@export var low_threshold: float = 0.25
@export var normal_color: Color = Color(0.9, 0.3, 0.35, 1)
@export var low_color: Color = Color(1, 0.85, 0.2, 1)
@export_range(0.05, 1.0, 0.05) var animation_time: float = 0.25

var _fill: StyleBoxFlat
var _tween: Tween


func _ready() -> void:
	assert(bar != null, "StatBar: brak 'bar'.")
	# Kopia stylu, żeby kolor jednego paska nie zmieniał drugiego.
	var shared: StyleBoxFlat = bar.get_theme_stylebox("fill") as StyleBoxFlat
	_fill = shared.duplicate() as StyleBoxFlat
	bar.add_theme_stylebox_override("fill", _fill)


## Podpina pasek pod statystykę i od razu pokazuje jej stan.
func bind(stat: StatComponent) -> void:
	stat.changed.connect(_on_stat_changed)
	_on_stat_changed(stat.current, stat.max_value, true)


func _on_stat_changed(current: int, maximum: int, instant: bool = false) -> void:
	bar.max_value = maximum
	if _tween != null:
		_tween.kill()
	if instant:
		bar.value = current
	else:
		_tween = create_tween()
		_tween.tween_property(bar, "value", float(current), animation_time)
	var is_low: bool = float(current) / float(maximum) <= low_threshold
	_fill.bg_color = low_color if is_low else normal_color
