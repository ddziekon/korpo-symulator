class_name Room
extends Node2D
## Pokój: maluje podłogę i ustawia granice kamery.

@export var floor_layer: TileMapLayer
@export var camera: FollowCamera
## Rozmiar podłogi w kafelkach.
@export var floor_size_cells: Vector2i = Vector2i(20, 12)
## Współrzędne kafelka podłogi w arkuszu (kolumna, wiersz).
@export var floor_tile_coords: Vector2i = Vector2i(5, 0)
## Granice kamery w pikselach (podłoga razem ze ścianami).
@export var camera_bounds: Rect2i = Rect2i(-16, -32, 352, 240)


func _ready() -> void:
	assert(floor_layer != null, "Room: brak przypisanej 'floor_layer'.")
	assert(camera != null, "Room: brak przypisanej 'camera'.")
	_paint_floor()
	camera.apply_world_bounds(camera_bounds)


func _paint_floor() -> void:
	for x: int in floor_size_cells.x:
		for y: int in floor_size_cells.y:
			floor_layer.set_cell(Vector2i(x, y), 0, floor_tile_coords)
