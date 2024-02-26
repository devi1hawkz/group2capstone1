extends Node2D

func _ready():
	spawner()
func spawner():
	var squareMob = preload("res://enemy_1.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	squareMob.global_position = %PathFollow2D.global_position
	add_child(squareMob)


func _on_spawn_timer_timeout():
	spawner()
	
