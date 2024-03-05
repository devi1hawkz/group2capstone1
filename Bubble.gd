extends Area2D

var distance = 0 

func _physics_process(delta):
	var move_speed = 700
	var range = 3000
	var dir = Vector2.RIGHT.rotated(rotation)
	position+=dir*move_speed*delta
	distance += move_speed*delta
	if distance > range:
		queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("damaged"):
		body.damaged(1)
