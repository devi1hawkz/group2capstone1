extends Control

@onready var select = $selected
func _ready():
	pass;


func _on_button_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_melee_b_pressed():
	Global.ranged = false
	Global.melee = true
	print("1")
	select.text=str("Selected weapon is melee")


func _on_ranged_b_pressed():
	Global.ranged = true
	Global.melee = false
	print("0")
	select.text=str("Selected weapon is ranged")
