extends Control

signal continue_game

func _on_continue_pressed():
	emit_signal("continue_game", false)
	self.hide()

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
