extends AnimatedSprite3D

func _ready() -> void:
	play()

func _on_animation_finished() -> void:
	print("EFEITO DO TIRO ACABOU!!!!11")
	queue_free()
