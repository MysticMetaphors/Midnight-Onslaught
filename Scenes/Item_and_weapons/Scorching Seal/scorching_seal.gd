extends Node2D

@export var damage_amount = 3.0
@export var damage_interval = 0.5 
@export var damage_timer = 0.0 

@onready var player = get_tree().get_first_node_in_group("Player")

var enemies_in_area = [] 

func _ready():
	if player:
		player.connect("player_level_up", damage_increase)

func damage_increase(amount):
	if player:
		damage_amount += damage_amount * amount
		print("Leveled ", damage_amount)
		
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


	
