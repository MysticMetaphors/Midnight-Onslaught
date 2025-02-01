extends Node2D

@export var attack_power = 7.0
@export var rotation_speed = 5.0
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	if player:
		player.connect("player_level_up", damage_increase)
		#print("found")

func damage_increase(amount):
	if player:
		attack_power += attack_power * amount
		#print("Leveled ", attack_power)
		
func _physics_process(delta): 
	$Marker2D.rotate(rotation_speed * delta)

func _on_area_2d_body_entered(body):
	if body.has_method("enemy_take_damage"):
		body.enemy_take_damage(attack_power)
