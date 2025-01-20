extends CharacterBody2D

const SPEED = 100.0

@onready var player = get_parent().get_node("Player")

func _physics_process(delta):
	var direction = (player.position - position).normalized()
	var distance_to_player = position.distance_to(player.position)
	
	position += direction * SPEED * delta

	move_and_slide()
