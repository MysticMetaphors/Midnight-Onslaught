extends Node2D

@export var attack_power = 20.0
@export var rotation_speed = 5.0

func _physics_process(delta): 
	$Marker2D.rotate(rotation_speed * delta)

func _on_area_2d_body_entered(body):
	if body.has_method("enemy_take_damage"):
		body.enemy_take_damage(attack_power)
		
