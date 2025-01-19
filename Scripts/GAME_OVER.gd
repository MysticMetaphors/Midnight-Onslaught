extends Control

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/world_map.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
