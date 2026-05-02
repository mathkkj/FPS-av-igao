extends CharacterBody3D
class_name Fabbri

signal MATOU_FABBRI

@export var dano_ao_jogador = 20
@export var vida = 200

@onready var explosao_cena = preload("res://particula_explosao.tscn")
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var SPEED = 3.0
var alvo = null
var morreu := false

func _physics_process(delta):
	if morreu:
		return

	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	velocity = (next_location - current_location).normalized() * SPEED
	move_and_slide()

	if vida <= 0:
		morreu = true
		MATOU_FABBRI.emit()

		var explosao = explosao_cena.instantiate()
		get_tree().current_scene.add_child(explosao)
		explosao.global_position = global_position

		await explosao.get_node("smoke").finished
		explosao.queue_free()
		queue_free()

func update_target_location(target_location):
	nav_agent.target_position = target_location

func dano(dano: int):
	if morreu:
		return
	vida -= dano
	print(vida)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == null:
		return
	if body.has_method("perder_vida"):
		alvo = body
		alvo.perder_vida(10)
		$Timer.start()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == alvo:
		alvo = null
		$Timer.stop()

func _on_timer_timeout() -> void:
	if alvo != null and is_instance_valid(alvo) and alvo.has_method("perder_vida"):
		alvo.perder_vida(dano_ao_jogador)
