extends Control

signal un_paused

func _on_continue_pressed():
	pass

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
