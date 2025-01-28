extends CharacterBody2D

const SPEED = 50
@onready var player = get_parent().get_node("Player")
@onready var anim = $AnimationPlayer

@export var attack = 20.0
@export var exp_amount: float = 20.0

signal enemy_died(exp_amount)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100.0
var player_in = true

var can_attack = true
var moving = true

func _physics_process(delta):
	#var direction = to_local(path.get_next_path_position()).normalized()
	if is_instance_valid(player):
		var direction = (player.position - position).normalized()
		var distance_to_player = position.distance_to(player.position)
		position += direction * SPEED * delta
		anim.play("move")
		if direction.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	else:
		anim.play("idle")
	move_and_slide()

func enemy_take_damage(amount):
	health -= amount
	$ProgressBar.set_value_no_signal(health)
	
	if health <= 0:
		die()
	
func die():
	var death = preload("res://Scenes/death_scene.tscn").instantiate()
	death.global_position = $".".global_position
	get_parent().add_child(death)
	emit_signal("enemy_died", exp_amount)
	opt_death()

func opt_death():
	$".".hide()
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true

func _on_area_2d_body_entered(body):
	if body.has_method("player_take_damage") and can_attack:
		anim.play("attack")
		body.player_take_damage(attack)
		can_attack = false
		can_attack = true
