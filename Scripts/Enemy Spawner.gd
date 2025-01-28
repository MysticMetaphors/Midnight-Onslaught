extends Node2D

@onready var player_check = $Player

var bodies = 0
var max_bodies = 40

func _ready():
	var frames = Engine.get_frames_per_second()
	print("frames per sec:", frames)
	if player_check:
		player_check.connect("player_died", _on_game_end)
	
	if is_instance_valid(player_check) and player_check.has_signal("game_paused"):
		player_check.connect("game_paused", _on_game_pause)

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
		
	if selected_object:
		selected_object.connect("enemy_died", _on_exp_gain)

func _on_timer_timeout():
	spawner()

func _on_game_end():
	#print("stopped_spawning")
	$Path2D/Timer.stop()

func _on_game_pause():
	Engine.time_scale = 0
	#print("Paused Successfully")
	
func _on_exp_gain(exp_amount):
	if is_instance_valid(player_check):
		player_check._on_player_level_up(exp_amount)
		bodies -= 1
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
