extends CharacterBody3D

var xp = 0

var sinal_xp_enviado = false


signal xp_maximo


var SPEED = 8.0
var ACCEL = 20.0
var JUMP = 5.5
var WALL_JUMP_FORCE = 6.0
var WALL_SLIDE_SPEED = -2.0


@onready var camera = $camera
var LIFE = 100
@onready var tomei_dano = $tomei_dano
@onready var progress_bar = $CanvasLayer/BarVida
@onready var progress_bar_xp = $CanvasLayer/BarXp

var parede_normal: Vector3

func _physics_process(delta: float) -> void:
	
	if xp >= 100 and not sinal_xp_enviado:
		sinal_xp_enviado = true
		xp_maximo.emit()
	
	
	if LIFE <= 0:
		get_tree().reload_current_scene()
	
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


func _ready() -> void:
	progress_bar.value = LIFE
	
func perder_vida(dano):
	tomei_dano.play()
	LIFE -= dano
	progress_bar.value = LIFE
	camera.shake_pos(0.1, 0.3)
	print("eu to com ", LIFE, " de vida")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$camera.rotation.y += -event.relative.x * 0.005
		$camera.rotation.x += -event.relative.y * 0.005
		$camera.rotation.x = clamp($camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		
	
func _on_caiu_no_void_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene()


func _on_inimigo_matou_fabbri() -> void:
	xp += 20
	progress_bar_xp.value = xp

	if xp >= 100 and not sinal_xp_enviado:
		sinal_xp_enviado = true
		xp_maximo.emit()
