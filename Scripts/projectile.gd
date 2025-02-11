extends Area2D

@export var enemy_is_target = true #Defult
@export var player_is_target = false
@export var attack_power = 7.0

var col_mask = [5, true]

var enemy_hit = false
var distance = 0
var RANGE = 600
var SPEED = 500
var color = null

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	if player and enemy_is_target == true:
		player.connect("player_level_up", damage_increase)

	self.set_collision_mask_value(col_mask[0], col_mask[1])
	if color:
		$particle_boss_proj/GPUParticles2D.self_modulate = color
func damage_increase(amount):
	if player:
		attack_power += attack_power * amount
		#print("Leveled ", attack_power)

func _physics_process(delta):
	var dir = Vector2.LEFT.rotated(rotation - 0.1)
	position += dir * SPEED * delta
	distance += SPEED * delta
	#print("RANGE: ", RANGE, " SPEED: ", SPEED, " DISTANCE: ", distance)
	if RANGE <= distance:
		queue_free()
		#printerr("freed")
	
func _on_body_entered(body):
	var enemies_body = body.has_method("enemy_take_damage")
	var player_body = body.has_method("player_take_damage") 
	if enemies_body and enemy_is_target == true:
		body.enemy_take_damage(attack_power)
		call_deferred("queue_free")
	
	if player_body and player_is_target == true:
		body.player_take_damage(attack_power)
		call_deferred("queue_free")
