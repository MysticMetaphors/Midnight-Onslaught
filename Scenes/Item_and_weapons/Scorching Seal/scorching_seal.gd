extends Node2D

@export var damage_amount = 10.0
@export var damage_interval = 1.0 
@export var damage_timer = 0.0 

@onready var player = get_parent()

var enemies_in_area = [] 

func _ready():
	player.connect("player_level_up", damage_increase)
	
func _process(delta):
	damage_timer -= delta

	if damage_timer <= 0:
		for enemy in enemies_in_area:
			if enemy and enemy.is_inside_tree():
				enemy.enemy_take_damage(damage_amount)  
		damage_timer = damage_interval 

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"): 
		enemies_in_area.append(body)

func _on_area_2d_body_exited(body):
	if body in enemies_in_area:
		enemies_in_area.erase(body)

func damage_increase(amount):
	if is_instance_valid(player):
		damage_amount += (100 * amount)
		print("Leveled ", damage_amount)
	
