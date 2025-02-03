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
	projectile_instance.player_is_target = true
	projectile_instance.enemy_is_target = false
	projectile_instance.SPEED = 200
	projectile_instance.col_mask = [1, true]
	get_parent().add_child(projectile_instance)
	
func _on_timer_timeout():
	if shooting:
		shoot_enemy()
