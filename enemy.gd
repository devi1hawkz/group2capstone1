extends CharacterBody2D

@export var move_speed = 20.0
@export var hp = 5
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	var dir = global_position.direction_to(player.global_position)
	velocity = dir*move_speed
	move_and_slide()

func damaged():
	hp -=1
	if hp == 0:
		queue_free()
