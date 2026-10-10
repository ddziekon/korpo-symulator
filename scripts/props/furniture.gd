class_name Furniture
extends StaticBody2D
## Mebel wycięty z arkusza (prostokąt w pikselach). Pozycja węzła to dolny środek mebla (potrzebne do Y-sortu).

@export var sheet: Texture2D
## Prostokąt sprite'a w arkuszu (w pikselach).
@export var region: Rect2i = Rect2i(0, 0, 16, 16)
## Rozmiar kolizji u podstawy mebla (w pikselach). Zero = mebel bez kolizji.
@export var collision_size: Vector2 = Vector2(16.0, 8.0)
@export var collision_shape: CollisionShape2D


func _ready() -> void:
	assert(sheet != null, "Furniture: brak przypisanego arkusza 'sheet'.")
	assert(collision_shape != null, "Furniture: brak przypisanego 'collision_shape'.")
	_build_sprite()
	_build_collision()


func _build_sprite() -> void:
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(region)
	var furniture_sprite: Sprite2D = Sprite2D.new()
	furniture_sprite.texture = atlas
	furniture_sprite.centered = false
	furniture_sprite.position = Vector2(-region.size.x / 2.0, -region.size.y)
	add_child(furniture_sprite)


func _build_collision() -> void:
	if collision_size == Vector2.ZERO:
		collision_shape.disabled = true
		return
	# Nowy kształt dla każdej instancji, żeby meble nie dzieliły jednego zasobu.
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = collision_size
	collision_shape.shape = shape
	collision_shape.position = Vector2(0.0, -collision_size.y / 2.0)
