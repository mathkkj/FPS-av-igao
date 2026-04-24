extends AnimatedSprite3D

func _ready() -> void:
	play()

func _on_animation_finished() -> void:
	print("animacao acabou")
	queue_free()
