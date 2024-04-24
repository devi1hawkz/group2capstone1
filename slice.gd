extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var distance = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var move_speed = 150
	var dir = Vector2.RIGHT.rotated(rotation)
	position += dir * move_speed * delta
	distance += move_speed*delta
	if distance > Global.melee_range:
		queue_free()

func _on_body_entered(body):
	if body.has_method("damaged"):
		%hit.play()
		body.damaged(Global.melee_atk_dmg)
