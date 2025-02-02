extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	self.set_physics_process(false)
	self.set_process(false)

func _physics_process(delta):
	printerr("running")
	if is_instance_valid(player):
		var direction = (player.position - position).normalized()
		var distance_to_player = position.distance_to(player.position)
		position += direction * 20 * delta
		print(player.position, "point: ", self.position)
		move_and_slide()

func _on_level_body_entered(body):
	if body.has_method("_on_player_level_up"):
		body._on_player_level_up(10.0)

func set_processes():
	self.set_physics_process(true)
	self.set_process(true)
