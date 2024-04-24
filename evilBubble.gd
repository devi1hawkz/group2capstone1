extends Area2D

var distance = 0 

func _physics_process(delta):
	var move_speed = 70
	var dir = Vector2.RIGHT.rotated(rotation)
	position+=dir*move_speed*delta
	distance += move_speed*delta
	#if distance > Global.range_range:
	#	queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		Global.hp -= 2
		queue_free()
