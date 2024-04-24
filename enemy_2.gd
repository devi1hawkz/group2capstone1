extends CharacterBody2D

@export var move_speed = 12.0
@export var hp = 7
@onready var main = get_node("/root/World")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var expval = 2
@onready var expgem = preload("res://gem.tscn")
@onready var sprite = $Sprite2D
@onready var walk = get_node("walkTimer")
@onready var atkSpd = 2
var frame_index = 0
var frame_count = 3
var frame_duration = 0.35
var timer
var elapsed_time = 0.0
var crystal_count = 2

func _ready():
	timer = Timer.new()
	timer.wait_time = frame_duration
	add_child(timer)
	timer.start()
	$shootTimer.start()

func _process(delta):
	elapsed_time += delta
	if elapsed_time >=frame_duration:
		frame_index = (frame_index + 1) % frame_count
		sprite.frame = frame_index
		elapsed_time = 0.0

func shoot_towards_player():
	var evilBubble = preload("res://evilBubble.tscn")
	var atk = evilBubble.instantiate()
	self.add_child(atk)
	atk.global_position = self.get_position()
	atk.look_at(get_node("/root/World/Player").get_position())

func _on_shoot_timer_timeout():
	shoot_towards_player()
	$shootTimer.start()

func _on_Timer_timeout():
	frame_index += 1
	frame_index %= frame_count
	sprite.frame = frame_index

func _physics_process(_delta):
	var dir = global_position.direction_to(player.global_position)
	velocity = dir*move_speed
	move_and_slide()
	var moves = dir
	if moves.x > 0:
		sprite.flip_h=false
	elif moves.x < 0:
		sprite.flip_h=true
	

func damaged(dmg):
	hp -=dmg
	if hp <= 0:
		death()

func death():
	for i in range(crystal_count):
		var new_gem = expgem.instantiate()
		new_gem.global_position = global_position + Vector2(10*i, 10*i)
		new_gem.xpmod = expval
		main.call_deferred("add_child",new_gem)
		queue_free()
