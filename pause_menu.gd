extends Control

func _on_continue_pressed():
	Engine.time_scale = 1
	self.hide()

func _on_return_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
