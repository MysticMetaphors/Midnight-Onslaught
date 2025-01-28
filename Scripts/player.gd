extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var exprience = $CanvasLayer/Exp
@export var health = 100.0
const SPEED: float = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var viewport_instance = preload("res://Scenes/viewport.tscn").instantiate()
var game_over_tcsn = preload("res://Scenes/game_over.tscn").instantiate()
var increase_amount = 0.1
#var max_health
var max_exp: float = 100.0
var expr: float = 0.0

signal player_died
signal player_level_up(increase_amount)
signal game_paused

func _ready():
	$"CanvasLayer/PAUSE-menu".hide()
	
	$CanvasLayer/health.value = health

	exprience.value = expr
	exprience.max_value = max_exp

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
	$CanvasLayer/health.value = health
	#print(health)
	if health <= 0 or Input.is_action_just_pressed("die"):
		#print("die")
		emit_signal("player_died")
		viewport_instance.global_position = $".".global_position
		get_parent().add_child(viewport_instance)
		game_over_tcsn.global_position = $".".global_position
		get_parent().add_child(game_over_tcsn)
		queue_free()

func _on_player_level_up(exp_amount):
	expr += exp_amount
	if expr >= max_exp:
		expr = 0
		max_exp += max_exp * 0.1
		emit_signal("player_level_up", increase_amount)
	exprience.value = expr
	#print(max_exp)
	#print($Exp.max_value)


func _on_pause_button_pressed():
	$"CanvasLayer/PAUSE-menu".show()
	emit_signal("game_paused")
