extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("Player")
var follow = false
var exp_amount = 10.0

signal enemy_died
signal picked(exp_amount)

func _ready():
	await get_tree().create_timer(0.3).timeout
	emit_signal("enemy_died")

func _physics_process(delta):
	if is_instance_valid(player) and follow:
		var direction = (player.position - position).normalized()
		var distance_to_player = position.distance_to(player.position)
		position += direction * 500 * delta
		move_and_slide()

func _on_level_body_entered(body):
	if body.has_method("_on_player_level_up"):
		emit_signal("picked", exp_amount)
		$CollisionShape2D.disabled = true
		$level/CollisionShape2D.disabled = true
		self.set_physics_process(false)
		self.hide()

func set_processes(set_sta: bool):
	follow = set_sta
	#printerr("set: ", set_sta)
