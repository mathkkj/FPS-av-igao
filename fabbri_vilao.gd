extends Fabbri

@onready var barra = $ProgressBar
@onready var textoVidaEvil = $Label3D
func _ready() -> void:
	print(nav_agent)

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	velocity = (next_location - current_location).normalized() * SPEED
	textoVidaEvil.text = str("Evil Fabbri (Gabbri):", vida)
	barra.value = vida
	
	move_and_slide()
	if vida <= 0:
		get_tree().quit()
