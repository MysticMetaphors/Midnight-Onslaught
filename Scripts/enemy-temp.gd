extends CharacterBody2D

const SPEED = 50
@onready var player = get_parent().get_node("Player")
@onready var path:=  $NavigationAgent2D as NavigationAgent2D
@onready var anim = $AnimationPlayer

@export var attack = 20
@export var exp_amount: float = 20.0

signal enemy_died(exp_amount)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100.0
var player_in = true

var can_attack = true
var moving = true

func _ready() -> void:
	find_path()
	Animation_handler()

func _physics_process(_delta: float):
	var direction = to_local(path.get_next_path_position()).normalized()

	if player_in == true:
		velocity = direction * SPEED 
		if velocity.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	else:
		moving = true
		velocity = Vector2.ZERO 
		anim.play("idle")
	move_and_slide()
	

func find_path():
	if is_instance_valid(player):
		if player:
			path.target_position = player.global_position
	else:
		path.velocity = Vector2.ZERO
		#die()

func _on_follow_timeout():
	if player_in == true and player:
		find_path()

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
	return

func opt_death():
	$".".hide()
	$Hitbox.disabled = true
	$Attack/CollisionShape2D.disabled = true
	$Follow.stop()

func _on_attack_body_entered(body):
	if body.has_method("player_take_damage") and can_attack:
		Animation_handler()
		anim.play("attack")
		body.player_take_damage(attack)
		can_attack = false
		get_tree().create_timer(1).timeout
		can_attack = true

func Animation_handler():
	if moving == true:
		anim.play("move")
	else: 
		anim.play("idle")
