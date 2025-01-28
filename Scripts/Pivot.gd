extends Area2D

var shooting = true


func _physics_process(_delta):
	var enemy_target = get_overlapping_bodies()
	if enemy_target.size() > 0:
		shooting = true
		var lock_target = enemy_target.front()
		look_at(lock_target.global_position)
	else:
		shooting = false
		
func shoot_enemy():
	var projectile_instance = preload("res://Scenes/projectile.tscn").instantiate()
	call_deferred("add_child", projectile_instance)
	
func _on_timer_timeout():
	if shooting:
		shoot_enemy()
