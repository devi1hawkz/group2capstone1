extends Control
@onready var f_select = $Panel
func _ready():
	pass

func _on_start_pressed():
	if Global.file_name != null:
		print(Global.file_name)
		get_tree().change_scene_to_file("res://node_2d.tscn")
	else:
		get_tree().paused=true
		f_select.show()

func _on_select_quiz_pressed():
	get_tree().change_scene_to_file("res://quiz_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://credits.tscn")


func _on_button_pressed():
	f_select.hide()
	get_tree().paused=false
