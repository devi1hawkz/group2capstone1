extends Area2D


func _physics_process(_delta):
	var enemies = get_overlapping_bodies()
	if enemies.size() > 0:
		var target = enemies[0]
		look_at(target.global_position)
		if $shootTime.time_left <= 0:
			$shootTime.start()

func shoot():
	var bubble = preload("res://bubble.tscn")
	var new_bubb = bubble.instantiate()
	owner.add_child(new_bubb)
	new_bubb.global_position = %shootPoint.global_position
	%pop.play()
	new_bubb.global_rotation = %shootPoint.global_rotation
	

func _on_shoot_time_timeout():
	shoot()
	$shootTime.start()
