extends CharacterBody3D

@export var vida = 100

@onready var nav_agent = $NavigationAgent3D

var SPEED = 3.0

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	velocity = (next_location - current_location).normalized() * SPEED
	
	move_and_slide()
	if vida <= 0:
		queue_free()
	
func update_target_location(target_location):
	nav_agent.target_position = target_location


func dano(dano: int):
	vida -= dano
	print(vida)
