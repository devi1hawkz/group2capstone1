extends CharacterBody2D

@export var move_speed = 20.0
@export var hp = 4
@onready var main = get_node("/root/World")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var expval = 2
@onready var expgem = preload("res://gem.tscn")

func _physics_process(_delta):
	var dir = global_position.direction_to(player.global_position)
	velocity = dir*move_speed
	move_and_slide()

func damaged(dmg):
	hp -=dmg
	if hp == 0:
		death()

func death():
	var new_gem = expgem.instantiate()
	new_gem.global_position = global_position
	new_gem.xpmod = expval
	main.call_deferred("add_child",new_gem)
	queue_free()
