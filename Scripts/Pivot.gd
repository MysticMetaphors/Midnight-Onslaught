extends Area2D

var shooting = true
var locked = null

func _physics_process(_delta):
	var enemy_target = get_overlapping_bodies()
	if enemy_target.size() > 0:
		shooting = true
		var lock_target = enemy_target.front()
		locked = lock_target
		look_at(lock_target.global_position)
	else:
		shooting = false
		
func shoot_enemy():
	var projectile_instance = preload("res://Scenes/projectile.tscn").instantiate()
	var root_parent = get_parent()

	#Default
	projectile_instance.rotate($".".global_rotation)
	projectile_instance.global_position = root_parent.global_position
	
	#Change status/var here
	projectile_instance.SPEED = 300

	for i in range(3):
		if root_parent:
			root_parent = root_parent.get_parent()

	if root_parent:
		root_parent.add_child(projectile_instance)
	else:
		printerr("Adjust_range")

func _on_timer_timeout():
	if shooting:
		shoot_enemy()
