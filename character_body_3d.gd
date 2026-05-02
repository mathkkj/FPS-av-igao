extends CharacterBody3D


const SPEED = 8.0
const ACCEL = 20.0
const JUMP = 5.5
const WALL_JUMP_FORCE = 6.0
const WALL_SLIDE_SPEED = -2.0

var parede_normal: Vector3

func _physics_process(delta: float) -> void:
	var direcao = Input.get_vector("esquerda", "direita", "cima", "baixo")
	var dir = Vector3(direcao.x, 0, direcao.y).rotated(Vector3.UP, $camera.rotation.y)

	# gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta


	
	#tipo um clamp (interporlaçao) 
	velocity.x = move_toward(velocity.x, dir.x * SPEED, ACCEL * delta)
	velocity.z = move_toward(velocity.z, dir.z * SPEED, ACCEL * delta)

	# wall slide
	if is_on_wall() and not is_on_floor() and velocity.y < 0:
		parede_normal = get_wall_normal()
		velocity.y = WALL_SLIDE_SPEED

	# pulo
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP
		#pula na parede
		elif is_on_wall():
			velocity.y = JUMP
			velocity += parede_normal * WALL_JUMP_FORCE

	move_and_slide()



func _unhandled_input(event):
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$camera.rotation.y += -event.relative.x * 0.005
		$camera.rotation.x += -event.relative.y * 0.005
		$camera.rotation.x = clamp($camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
		
#func atirar_raio_da_camera_fps(mouse_pos: Vector2):
	#var camera = get_viewport().get_camera_3d()
	#if camera == null:
		#return null
	#
	#var origin = camera.project_ray_origin(mouse_pos)
	#var end = origin + camera.project_ray_normal(mouse_pos) * 1000
	#var space_state = get_world_3d().direct_space_state
	#
	#var query = PhysicsRayQueryParameters3D.create(origin, end)
	#query.exclude = [get_rid()]
	#var result = space_state.intersect_ray(query)
	#
	#if result.is_empty():
		#return null
	#else:
		#return result
#
#
#func atirar_projetil(from):
	#var alvo = atirar_raio_da_camera_fps(from)
	#if alvo == null:
		#return
	#
	#if alvo.collider.has_method("dano"):
		#alvo.collider.dano(50)
	#else:
		#var dcl = decal_spr.instantiate()
		#dcl.global_position = alvo.position + (alvo.normal * 0.01)
		#dcl.look_at(alvo.position + alvo.normal, Vector3.UP, true)
	#
		#var impct = impact.instantiate()
		#impct.global_position = alvo.position + (alvo.normal * 0.02)
		#
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#atirar_projetil(event.position)
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		#for i in range(1, 10):
			#atirar_projetil(event.position)
