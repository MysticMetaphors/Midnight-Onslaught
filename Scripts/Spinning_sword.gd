extends Node2D

@export var attack_power = 15.0
@export var rotation_speed = 5.0

@onready var player = get_parent()
func _ready():
	player.connect("player_level_up", damage_increase)

func damage_increase(amount):
	if is_instance_valid(player):
		attack_power += attack_power * amount
		#print("Leveled ", attack_power)
		
func _physics_process(delta): 
	$Marker2D.rotate(rotation_speed * delta)

func _on_area_2d_body_entered(body):
	if body.has_method("enemy_take_damage"):
		body.enemy_take_damage(attack_power)
		
