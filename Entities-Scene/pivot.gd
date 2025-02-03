extends Area2D

var shooting = true

func _physics_process(_delta):
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		shooting = true
		var lock_target = player
		look_at(lock_target.global_position)
	else:
		shooting = false
		
func shoot_enemy():
	var projectile_instance = preload("res://Scenes/projectile.tscn").instantiate()
	call_deferred("add_child", projectile_instance)
	
func _on_timer_timeout():
	if shooting:
		shoot_enemy()
