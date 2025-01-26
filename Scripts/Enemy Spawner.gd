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
	var enemy_scene = preload("res://Entities-Scene/enemy_temp.tscn").instantiate()
	$Path2D/PathFollow2D.progress_ratio = randf()
	if is_instance_valid(enemy_scene) and max_bodies >= bodies:
		enemy_scene.global_position = $Path2D/PathFollow2D.global_position
		call_deferred("add_child", enemy_scene)
		bodies += 1
		#print(bodies)
		
	if enemy_scene:
		enemy_scene.connect("enemy_died", _on_exp_gain)
	
func _on_timer_timeout():
	spawner()

func _on_game_end():
	#print("stopped_spawning")
	$Path2D/Timer.stop()

func _on_game_pause():
	print("Paused Successfully")
	
func _on_exp_gain(exp_amount):
	if is_instance_valid(player_check):
		if player_check.has_method("exprience_gain"):
			player_check.exprience_gain(exp_amount)
			bodies -= 1
	#$CanvasLayer/Label.text = '%03d' % [bodies]

func _on_spawn_controller_timeout():
	max_bodies += 10
	if $Path2D/Timer.wait_time <= 0.2:
		$Path2D/Timer.wait_time = 0.1
		$Path2D/Spawn_Controller.stop()
		#print("last_update: ", $Path2D/Timer.wait_time)
	else: 
		$Path2D/Timer.wait_time -= (0.2/100*(100))
		#print("wait_time set to: ", $Path2D/Timer.wait_time)
