extends Control

@onready var select = $selected
func _ready():
	pass;


func _on_button_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_melee_b_pressed():
	Global.ranged = false
	Global.melee = true
	select.text=str("Selected weapon is melee")


func _on_ranged_b_pressed():
	Global.ranged = true
	Global.melee = false
	select.text=str("Selected weapon is ranged")


func _on_back_b_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
