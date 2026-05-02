extends Fabbri

@onready var barra = $ProgressBar

func _ready() -> void:
	print(nav_agent)

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	velocity = (next_location - current_location).normalized() * SPEED
	
	barra.value = vida
	
	move_and_slide()
	if vida <= 0:
		get_tree().quit()
