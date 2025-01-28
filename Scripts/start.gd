extends Control
func _ready():
	$TRANSITION_SCENE/CanvasLayer.hide()

func _on_start_pressed():
	$TRANSITION_SCENE/CanvasLayer.show()
	$TRANSITION_SCENE/AnimationPlayer.play("Transition")
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_file("res://Scenes/world_map.tscn")

func _on_setting_pressed():
	$SETTING.show()

func _on_exit_pressed():
	get_tree().quit()


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
