extends Area2D

var shooting = false

func _physics_process(_delta):
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var lock_target = player
		look_at(lock_target.global_position)
		
func shoot_enemy():
	var projectile_instance = preload("res://Scenes/projectile.tscn").instantiate()
	var root_parent = get_parent()
	
	#Default
	projectile_instance.global_position = root_parent.global_position
	projectile_instance.rotate($".".global_rotation)
	
	#Change status/var here
	projectile_instance.player_is_target = true
	projectile_instance.enemy_is_target = false
	projectile_instance.SPEED = 100
	projectile_instance.RANGE = 200
	projectile_instance.col_mask = [1, true]
	projectile_instance.color = Color(0.133, 0.133, 0.133)
	
	for i in range(2):
		if root_parent:
			root_parent = root_parent.get_parent()

	if root_parent:
		root_parent.add_child(projectile_instance)
	else:
		printerr("Adjust_range")
	
func _on_timer_timeout():
	if shooting:
		shoot_enemy()
		#printerr("shoot")
