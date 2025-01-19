extends Node2D

func _ready():
	$AnimationPlayer.play("death")
	await get_tree().create_timer(1.0).timeout
	queue_free()
