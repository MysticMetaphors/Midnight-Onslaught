extends CharacterBody2D

const SPEED = 20
@onready var player = get_parent().get_node("Player")
@onready var anim = $AnimationPlayer

@export var attack = 20.0
@export var exp_amount: float = 20.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 10.0
var player_in = true

var can_attack = true
var moving = true

func _ready():
	$ProgressBar.value = health
	$ProgressBar.max_value = health

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
	move_and_slide()

func enemy_take_damage(amount):
	health -= amount
	$ProgressBar.set_value_no_signal(health)
	
	if health <= 0:
		die()
	
func die():
	var death = preload("res://Scenes/death_scene.tscn").instantiate()
	var level_point = preload("res://Entities-Scene/level_points.tscn").instantiate()
	death.global_position = $".".global_position
	level_point.global_position = $".".global_position
	get_parent().add_child(death)
	get_parent().add_child(level_point)
	opt_death()

func opt_death():
	$pivot/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	$Timer.paused =true
	self.set_process(false)
	self.set_physics_process(false)
	
	
func _on_attack_body_entered(body):
	if body.has_method("player_take_damage") and can_attack:
		anim.play("attack")
		body.player_take_damage(attack)
		can_attack = false
		can_attack = true
