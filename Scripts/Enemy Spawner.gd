extends Node2D

@onready var player_check = $Player
@onready var pause_menu = $"UI/PAUSE-menu"

var lvl_points_con: Array = []
var bodies = 0
var max_bodies = 40

func _ready():
	_on_game_pause(true)
	pause_menu.connect("continue_game", _on_game_pause)
	
	if is_instance_valid(player_check) and player_check.has_signal("game_paused"):
		player_check.connect("game_paused", _on_game_pause)
		player_check.connect("player_died", _on_game_end)

func _process(delta):
	var level_points = get_tree().get_nodes_in_group("Level_points")
	if level_points:
		for i in level_points:
			if i not in lvl_points_con: 
				i.connect("picked", _on_exp_gain)
				i.connect("enemy_died", enemy_population_handler)
				lvl_points_con.append(i)
			#printerr("found: ", get_tree().get_node_count_in_group("Level_points"))
	#else:
		#printerr("not found")

func spawner():
	var enemy_skeleton = preload("res://Entities-Scene/skeleton.tscn").instantiate()
	var enemy_scene = preload("res://Entities-Scene/enemy_temp.tscn").instantiate()
	
	var enem_arr: Array = [enemy_skeleton, enemy_scene]
	var selecting_Object = randi() % enem_arr.size()
	var selected_object = enem_arr[selecting_Object]
	
	$Path2D/PathFollow2D.progress_ratio = randf()
	if is_instance_valid(selected_object):
		selected_object.global_position = $Path2D/PathFollow2D.global_position
		call_deferred("add_child", selected_object)
		bodies += 1
		#print(selected_object)

func _on_timer_timeout():
	if bodies < max_bodies:
		spawner()

func _on_game_end():
	#print("stopped_spawning")
	$Path2D/Timer.stop()

func _on_game_pause(pause: bool):
	var objects_pause = get_tree().get_nodes_in_group("allow_pause")
	for each in objects_pause:
		each.set_process(!pause)
		each.set_physics_process(!pause)
		each.set_process_input(!pause)  # Stops input handling  
		 # Pause Animations
		if each.has_node("AnimationPlayer"):
			var anim = each.get_node("AnimationPlayer")
			if pause:
				anim.stop()
			else:
				anim.play()
		# Pause Timers
		for timer in each.get_children():
			if timer is Timer:
				timer.paused = pause
	#print("Paused Successfully")

func enemy_population_handler():
	bodies -= 1
	#print("bodies: ", bodies)
	#print("max_bodies: ", max_bodies)
	
func _on_exp_gain(exp_amount):
	if is_instance_valid(player_check):
		player_check._on_player_level_up(exp_amount)
	#$CanvasLayer/Label.text = '%03d' % [bodies]

func _on_spawn_controller_timeout():
	max_bodies += 10
	if $Path2D/Timer.wait_time <= 0.2:
		$Path2D/Timer.wait_time = 0.1
		$Path2D/Spawn_Controller.stop()
		#print("last_update: ", $Path2D/Timer.wait_time)
	else: 
		$Path2D/Timer.wait_time -= 0.2
		#print("wait_time set to: ", $Path2D/Timer.wait_time)

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()

func _on_pause_button_pressed():
	_on_game_pause(true)
	$"UI/PAUSE-menu".show()
