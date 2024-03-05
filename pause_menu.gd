extends Control

@onready var main = $"../../../"

func _ready():
	pass # Replace with function body.

func _on_unpause_pressed():
	main.pauseMenu()


func _on_quit_pressed():
	get_tree().quit()


func _on_mainmenu_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
