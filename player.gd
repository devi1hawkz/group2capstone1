extends CharacterBody2D

var move_spd = 55.0
var hp = 100
signal hp_zero

func _physics_process(delta):
	move()
	var overlap = %playerHurtbox.get_overlapping_bodies()
	if overlap.size()>0:
		hp -= 2 * overlap.size() * delta
		%healthbar.value=hp
		if hp <= 0.0:
			hp_zero.emit()

func move():
	var x_move = -Input.get_action_strength("left") + Input.get_action_strength("right")
	var y_move = -Input.get_action_strength("up") + Input.get_action_strength("down")
	var move = Vector2(x_move,y_move)
	velocity = move.normalized()*move_spd
	move_and_slide()


