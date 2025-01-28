extends Area2D

var damage = 20
var enemy_hit = false
var distance = 0

func _physics_process(delta):
	var dir = Vector2.RIGHT.rotated(rotation)
	const RANGE = 1000
	const SPEED = 500
	position += dir * 700 * delta
	#if enemy_hit == true:
		#dir = Vector2.ZERO
	
	distance += SPEED * delta
	if RANGE <= SPEED:
		call_deferred("queue_free")

func _on_body_entered(body):
	if body.has_method("enemy_take_damage"):
		body.enemy_take_damage(damage)
		call_deferred("queue_free")
	#if body_entered:
		#enemy_hit = true
		#$CollisionShape2D.disabled = true
		#explosion_instance.explo_pos = Vector2.ZERO
		#$CollisionShape2D.add_child(explosion_instance)
	
