extends Area2D

@export var xpmod = 1
@onready var gem  = $Sprite2D
@onready var collis = $CollisionShape2D
@onready var sound = $AudioStreamPlayer
var blue_gem = preload("res://Textures/Gem.png")
var target = null
var move_spd = -1

func _ready():
	if xpmod < 5:
		return
	else:
		return

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position ,move_spd)
		move_spd += 2*delta

func collect():
	sound.play()
	collis.call_deferred("set","disabled",true)
	gem.visible=false
	return xpmod

func _on_audio_stream_player_finished():
	queue_free()
