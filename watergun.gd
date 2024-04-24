extends Area2D

var shootCount=0
var multThresh

func _physics_process(_delta):
	if Global.ranged == true:
		multThresh=Global.range_atk_count
		$shootTime.wait_time = Global.range_atk_spd
		var enemies = get_overlapping_bodies()
		if enemies.size() > 0:
			var target = enemies[0]
			look_at(target.global_position)
			if $shootTime.time_left <= 0:
				$shootTime.start()
			

func shoot():
	var bubble = preload("res://Bubble.tscn")
	var new_bubb = bubble.instantiate()
	owner.add_child(new_bubb)
	new_bubb.global_position = %shootPoint.global_position
	%pop.play()
	new_bubb.global_rotation = %shootPoint.global_rotation
	

func _on_shoot_time_timeout():
	shoot()
	shootCount+=1
	if Global.range_atk_spd != $shootTime.wait_time:
		$shootTime.wait_time = Global.range_atk_spd
	if Global.range_atk_count!=(multThresh):
		multThresh=Global.range_atk_count
	if (shootCount==multThresh):
		$multishootTime.start()
		shootCount=0
	else:
		$shootTime.start()


func _on_multishoot_time_timeout():
	shoot()
	$shootTime.start()
