class_name Furniture
extends StaticBody2D
## Mebel zbudowany z kafelków arkusza. Pozycja węzła to dolny środek mebla (potrzebne do Y-sortu).

## Rozmiar kafelka w pikselach.
const CELL_SIZE: int = 16
## Krok w arkuszu: kafelek 16 px + 1 px odstępu.
const CELL_STEP: int = 17

@export var sheet: Texture2D
## Lewy górny kafelek mebla w arkuszu (kolumna, wiersz).
@export var origin_cell: Vector2i = Vector2i.ZERO
## Ile kafelków zajmuje mebel (szerokość, wysokość).
@export var size_cells: Vector2i = Vector2i.ONE
## Rozmiar kolizji u podstawy mebla (w pikselach).
@export var collision_size: Vector2 = Vector2(16.0, 8.0)
@export var collision_shape: CollisionShape2D


func _ready() -> void:
	assert(sheet != null, "Furniture: brak przypisanego arkusza 'sheet'.")
	assert(collision_shape != null, "Furniture: brak przypisanego 'collision_shape'.")
	_build_sprites()
	_build_collision()


func _build_sprites() -> void:
	var total_size: Vector2 = Vector2(size_cells * CELL_SIZE)
	var top_left: Vector2 = Vector2(-total_size.x / 2.0, -total_size.y)
	# Każdy kafelek to osobny Sprite2D, bo w arkuszu między kafelkami jest 1 px odstępu.
	for x: int in size_cells.x:
		for y: int in size_cells.y:
			var cell: Vector2i = origin_cell + Vector2i(x, y)
			var atlas: AtlasTexture = AtlasTexture.new()
			atlas.atlas = sheet
			atlas.region = Rect2(Vector2(cell * CELL_STEP), Vector2(CELL_SIZE, CELL_SIZE))
			var tile_sprite: Sprite2D = Sprite2D.new()
			tile_sprite.texture = atlas
			tile_sprite.centered = false
			tile_sprite.position = top_left + Vector2(x * CELL_SIZE, y * CELL_SIZE)
			add_child(tile_sprite)


func _build_collision() -> void:
	# Nowy kształt dla każdej instancji, żeby meble nie dzieliły jednego zasobu.
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = collision_size
	collision_shape.shape = shape
	collision_shape.position = Vector2(0.0, -collision_size.y / 2.0)
