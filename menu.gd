extends Control

func _ready():
	pass

func _on_start_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")

func _on_select_quiz_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://credits.tscn")
