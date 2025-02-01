extends Area2D

var attack_power = 7.0
var enemy_hit = false
var distance = 0

@onready var player = get_tree().get_first_node_in_group("Player")
func _ready():
	if player:
		player.connect("player_level_up", damage_increase)

func damage_increase(amount):
	if player:
		attack_power += attack_power * amount
		#print("Leveled ", attack_power)

func _physics_process(delta):
	var dir = Vector2.RIGHT.rotated(rotation)
	const RANGE = 1000
	const SPEED = 500
	position += dir * 700 * delta
	#if enemy_hit == true:
		#dir = Vector2.ZERO
	
	distance += SPEED * delta
	if RANGE <= SPEED:
		call_deferred("queue_free")

func _on_body_entered(body):
	if body.has_method("enemy_take_damage"):
		body.enemy_take_damage(attack_power)
		call_deferred("queue_free")
	
