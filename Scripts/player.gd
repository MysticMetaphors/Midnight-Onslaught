extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var exprience = $Exp
@export var health = 100.0
const SPEED = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var viewport_instance = preload("res://Scenes/viewport.tscn").instantiate()
var game_over_tcsn = preload("res://Scenes/game_over.tscn").instantiate()

signal player_died

var expr: float = 0.0
var exp_max_value = 100

func _ready():
	$health.value = health
	exprience.value = expr

func _physics_process(_delta):
	var direction_side = Input.get_axis("ui_left", "ui_right")
	var direction_topdown = Input.get_axis("ui_down", "ui_up")
		
	if direction_side:
		velocity.x = direction_side * SPEED 
		if velocity.x <= -1:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction_topdown:
		velocity.y = direction_topdown * -SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()
	animation_handler()

func animation_handler():
	if velocity != Vector2.ZERO:
		animation_player.play("move")
	else:
		animation_player.play("idle")

func player_take_damage(amount):
	health -= amount
	$health.value = health
	#print(health)
	if health <= 0 or Input.is_action_just_pressed("die"):
		#print("die")
		emit_signal("player_died")
		viewport_instance.global_position = $".".global_position
		get_parent().add_child(viewport_instance)
		game_over_tcsn.global_position = $".".global_position
		get_parent().add_child(game_over_tcsn)
		queue_free()

func exprience_gain(exp_amount):
	expr += exp_amount
	#if expr <= exp_val:
		#pass
	exprience.value = expr
	#print($Exp.value)
