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
var level: int = 1

var choosen_weapon_amount: int = 0

signal player_died
signal player_level_up(increase_amount)
signal game_paused

func _ready():
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
		level += 1
		max_exp += max_exp * 0.1
		emit_signal("player_level_up", increase_amount)
	exprience.value = expr
	
	if choosen_weapon_amount != 3:
		if level % 10 == 0:
			$"CanvasLayer/WEAPON CHOOSE".show()
			emit_signal("game_paused")
	#print(max_exp)
	#print($Exp.max_value)
	
func hide_canvas_choose():
	$"CanvasLayer/WEAPON CHOOSE".hide()
	emit_signal("game_paused", false)
	choosen_weapon_amount += 1

func _on_cardfireball_pressed():
	var fireball = preload("res://Scenes/projectile_loader.tscn").instantiate()
	$CanvasGroup.add_child(fireball)
	$"CanvasLayer/WEAPON CHOOSE/VBoxContainer/HBoxContainer/Card-FireBall/Card-fireball".disabled = true
	hide_canvas_choose()

func _on_cardcutlass_pressed():
	var cutlass = preload("res://Entities-Scene/spinning_sword.tscn").instantiate()
	$CanvasGroup.add_child(cutlass)
	$"CanvasLayer/WEAPON CHOOSE/VBoxContainer/HBoxContainer/card-cutlass/Card-cutlass".disabled = true
	hide_canvas_choose()

func _on_cardscorch_seal_pressed():
	var scorch_seal = preload("res://Scenes/Item_and_weapons/Scorching Seal/scorching_seal.tscn").instantiate()
	$CanvasGroup.add_child(scorch_seal)
	$"CanvasLayer/WEAPON CHOOSE/VBoxContainer/HBoxContainer/card-Scorch-seal/Card-scorchSeal".disabled = true
	hide_canvas_choose()
