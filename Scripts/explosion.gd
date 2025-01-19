extends Node2D

var explo_pos: Vector2

func _ready():
	self.global_position = explo_pos
	await get_tree().create_timer(0.2).timeout
	queue_free()
func _on_area_2d_body_entered(body):
	if body.has_method("enemy_take_damage"):
		body.enemy_take_damage(10)
