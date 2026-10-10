class_name ZzzSpawner
extends Marker2D
## Co jakiś czas tworzy unoszące się litery "z" (na przemian małe i duże).

@export var particle_scene: PackedScene
@export var small_texture: Texture2D
@export var big_texture: Texture2D
@export var timer: Timer
@export_range(0.2, 3.0, 0.1) var interval: float = 0.9
## Przesunięcie litery od punktu startowego w ciągu jej życia (w pikselach).
@export var drift: Vector2 = Vector2(10.0, -22.0)
@export_range(0.2, 4.0, 0.1) var lifetime: float = 1.8

var _spawned_count: int = 0


func _ready() -> void:
	assert(particle_scene != null, "ZzzSpawner: brak 'particle_scene'.")
	assert(timer != null, "ZzzSpawner: brak 'timer'.")
	timer.wait_time = interval
	timer.one_shot = false
	timer.timeout.connect(_spawn)


func start() -> void:
	_spawned_count = 0
	timer.start()
	_spawn()


func stop() -> void:
	timer.stop()


func _spawn() -> void:
	var particle: ZzzParticle = particle_scene.instantiate() as ZzzParticle
	add_child(particle)
	var use_big: bool = _spawned_count % 2 == 1
	_spawned_count += 1
	particle.launch(big_texture if use_big else small_texture, drift, lifetime)
