class_name Room
extends Node2D
## Pokój: maluje podłogę i ustawia granice kamery.

@export var floor_layer: TileMapLayer
@export var wall_layer: TileMapLayer
@export var camera: FollowCamera
## Rozmiar podłogi w kafelkach.
@export var floor_size_cells: Vector2i = Vector2i(20, 12)
## Lewy górny kafelek wzoru podłogi w arkuszu (wzór 3x2 powtarzany po całej podłodze).
@export var floor_pattern_origin: Vector2i = Vector2i(11, 13)
## Lewy górny kafelek wzoru ściany w arkuszu (wzór 3x2: góra i dół ściany).
@export var wall_pattern_origin: Vector2i = Vector2i(0, 11)
## Granice kamery w pikselach (podłoga razem ze ścianami).
@export var camera_bounds: Rect2i = Rect2i(-16, -48, 352, 256)


func _ready() -> void:
	assert(floor_layer != null, "Room: brak przypisanej 'floor_layer'.")
	assert(wall_layer != null, "Room: brak przypisanej 'wall_layer'.")
	assert(camera != null, "Room: brak przypisanej 'camera'.")
	_paint_floor()
	_paint_top_wall()
	camera.apply_world_bounds(camera_bounds)


func _paint_floor() -> void:
	for x: int in floor_size_cells.x:
		for y: int in floor_size_cells.y:
			floor_layer.set_cell(Vector2i(x, y), 0, floor_pattern_origin + Vector2i(x % 3, y % 2))


## Ściana nad podłogą ma 2 kafelki wysokości (współrzędne y = -2 i -1).
func _paint_top_wall() -> void:
	for x: int in floor_size_cells.x:
		for row: int in 2:
			wall_layer.set_cell(Vector2i(x, row - 2), 0, wall_pattern_origin + Vector2i(x % 3, row))
