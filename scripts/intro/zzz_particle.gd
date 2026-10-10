class_name ZzzParticle
extends Sprite2D
## Pojedyncza litera "z": unosi się w górę, pojawia się i zanika, po czym sama się usuwa.


func launch(new_texture: Texture2D, drift: Vector2, lifetime: float) -> void:
	texture = new_texture
	modulate.a = 0.0
	var move: Tween = create_tween()
	move.tween_property(self, "position", position + drift, lifetime)
	var fade: Tween = create_tween()
	fade.tween_property(self, "modulate:a", 1.0, lifetime * 0.3)
	fade.tween_property(self, "modulate:a", 0.0, lifetime * 0.7)
	fade.tween_callback(queue_free)
