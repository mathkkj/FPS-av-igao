extends StaticBody3D

@export var vida = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if vida == 0:
		queue_free()
		
func dano(dano: int):
	vida -= dano
	print(vida)
