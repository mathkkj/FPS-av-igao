extends Node3D

var zoomado = false
var fov_normal = 75
var fov_zoom = 40
var fov_alvo = 75

var atirando = false
var cadencia = 0.50
var tempo_ate_disparar = 0

const impact = preload("res://impacto.tscn")
const decal_spr = preload("res://bullethole_sprite.tscn")

@onready var player = $personagem
@onready var camera = $personagem/camera
@onready var cajado = $personagem/camera/cajadaodemadeira
@onready var anim = $personagem/AnimationPlayer

@onready var cena_fabbri = preload("res://inimigo.tscn")
@onready var cena_fabbri_mal = preload("res://fabbri_vilao.tscn")


func _ready() -> void:
	player.xp_maximo.connect(self._on_personagem_xp_maximo)
	#talvez n funcione
	
func _physics_process(delta: float) -> void:
	get_tree().call_group("inimigos", "update_target_location", player.global_transform.origin)
	camera.fov = move_toward(camera.fov, fov_alvo, 500 * delta)
	
	if atirando:
		tempo_ate_disparar -= delta
		if tempo_ate_disparar <= 0.0:
			atirar_projetil(get_viewport().get_mouse_position())
			tempo_ate_disparar = cadencia
	
func atirar_raio_da_camera_fps(mouse_pos: Vector2):
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return null
	
	var origin = camera.project_ray_origin(mouse_pos)
	var end = origin + camera.project_ray_normal(mouse_pos) * 1000
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [player.get_rid()]
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
		alvo.collider.dano(10)
		print("colidiu em um alvo que recebe dano")
	else:
		var impct = impact.instantiate()
		add_child(impct)
		impct.global_position = alvo.position + (alvo.normal * 0.01)
		impct.look_at(alvo.position + alvo.normal, Vector3.UP, true)
		
		var dcl = decal_spr.instantiate()
		add_child(dcl)
		dcl.global_position = alvo.position + (alvo.normal * 0.02)
		print("atirou e instancionou os decal")
	

func atirar_projetil_spray(mouse_pos: Vector2):
	var alvo = atirar_raio_da_camera_fps(mouse_pos)
	if alvo == null:
		return
	
	if alvo.collider.has_method("dano"):
		alvo.collider.dano(10)
		
		print("colidiu em um alvo que recebe dano")
	else:
		var impct = impact.instantiate()
		add_child(impct)
		impct.global_position = alvo.position + (alvo.normal * 0.01)
		impct.look_at(alvo.position + alvo.normal, Vector3.UP, true)
		
		var dcl = decal_spr.instantiate()
		add_child(dcl)
		dcl.global_position = alvo.position + (alvo.normal * 0.02)
		print("atirou e instancionou os decal")
	



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			atirar_projetil(event.position)
			atirando = true
			tempo_ate_disparar = 0
		else:
			atirando = false
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		for i in range(3):
			var spray = Vector2(
				randf_range(-10, 7),
				randf_range(-10, 7)
			)
			atirar_projetil(event.position + spray)
			
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
		alternar_zoom()

func alternar_zoom():
	zoomado = !zoomado
	
	
	if zoomado:
		player.ACCEL = player.SPEED / 2
		fov_alvo = fov_zoom
		anim.play("zoom_in")
	else:
		player.ACCEL = player.SPEED * 2
		fov_alvo = fov_normal
		anim.play("zoom_out")


func _on_spawn_timeout() -> void:
	var fabbri = cena_fabbri.instantiate()
	var pos_z = randf_range(2.861, -9.934)
	var pos_x = randf_range(-9.352, 6.028 )
	fabbri.position = Vector3(pos_x, 0.734, pos_z)
	add_child(fabbri)
	fabbri.MATOU_FABBRI.connect(player._on_inimigo_matou_fabbri)





func _on_personagem_xp_maximo() -> void:
	$spawn.stop()
	print("xp maximo")
	var fabbri = cena_fabbri_mal.instantiate()
	#var pos_z = randf_range(2.861, -9.934)
	#var pos_x = randf_range(-9.352, 6.028 )
	fabbri.position = Vector3(0, 1, 0)
	add_child(fabbri)
