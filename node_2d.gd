extends Node2D

@onready var p_menu = $Player/Camera2D/pause_menu
@onready var q_menu = $Player/Camera2D/QuizPanel
var paused = false

@onready var QuestionText = $Player/Camera2D/QuizPanel/Question_Name
@onready var ListItem = $Player/Camera2D/QuizPanel/ItemList
@onready var corrAns = $Player/Camera2D/QuizPanel/CorrectAns
@onready var okButton = $Player/Camera2D/QuizPanel/okButton
var file_path = "res://Quiz Files/test.json"

var items: Array = read_json_file("res://Quiz Files/test.json")
var item: Dictionary
var index_item: int = 0
var correct: bool = false

func read_json_file(filename):
	var json_as_text = FileAccess.get_file_as_string(filename)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict

var questions : Array = read_json_file(file_path)

func quiz_question():
	ListItem.clear()
	corrAns.text = ""
	item = items.pick_random()
	QuestionText.text = item.question
	var opts = item.options
	for opt in opts:
		ListItem.add_item(opt)


func _on_item_list_item_selected(index):
	if index == item.correctAns:
		corrAns.text = "Correct!"
		correct = true
		okButton.show()
	else:
		corrAns.text = "Incorrect. The correct answer is " + item.options[item.correctAns]
		okButton.show()

func _on_ok_button_pressed():
	if correct == true:
		level_reward()
	else:
		q_menu.hide()
		get_tree().paused=false

func level_reward():
	q_menu.hide()
	get_tree().paused=false

func get_rand(arr_length):
	var r = randf_range(0,arr_length);
	return r


func _ready():
	spawner()
	randomize()
	
func spawner():
	var squareMob = preload("res://enemy_1.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	squareMob.global_position = %PathFollow2D.global_position
	add_child(squareMob)

func _on_spawn_timer_timeout():
	spawner()
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		p_menu.hide()
		Engine.time_scale = 1
	else: 
		p_menu.show()
		Engine.time_scale = 0
	paused = !paused

func level_up():
	if paused:
		q_menu.hide()
		Engine.time_scale = 1
	else:
		q_menu.show()
		get_tree().paused = true
		quiz_question()
