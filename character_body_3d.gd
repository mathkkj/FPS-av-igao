extends CharacterBody3D


const SPEED = 3

const impact = preload("res://impacto.tscn")
const decal_spr = preload("res://bullethole_sprite.tscn")



func _physics_process(delta: float) -> void:
	var direcao = Input.get_vector("esquerda","direita","cima","baixo") * SPEED
	velocity = Vector3(direcao.x,velocity.y,direcao.y).rotated(Vector3.UP,$camera.rotation.y)
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$camera.rotation.y += -event.relative.x * 0.005
		$camera.rotation.x += -event.relative.y * 0.005
		$camera.rotation.x = clamp($camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func atirar_raio_da_camera_fps(mouse_pos: Vector2):
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return null
	
	var origin = camera.project_ray_origin(mouse_pos)
	var end = origin + camera.project_ray_normal(mouse_pos) * 1000
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [get_rid()]
	var result = space_state.intersect_ray(query)
	
	if result.is_empty():
		return null
	else:
		return result


func atirar_projetil(from):
	var alvo = atirar_raio_da_camera_fps(from)
	if alvo == null:
		return
	
	if alvo.collider.has_method("dano"):
		alvo.collider.dano(50)
	else:
		var dcl = decal_spr.instantiate()
		add_child(dcl)
		dcl.global_position = alvo.position + (alvo.normal * 0.01)
		dcl.look_at(alvo.position + alvo.normal, Vector3.UP, true)
	
		var impct = impact.instantiate()
		add_child(impct)
		impct.global_position = alvo.position + (alvo.normal * 0.02)
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		atirar_projetil(event.position)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		for i in range(1, 10):
			atirar_projetil(event.position)
