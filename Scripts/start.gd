extends Control

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/world_map.tscn")

func _on_setting_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit()
