extends Node2D

@onready var p_menu = $Player/Camera2D/pause_menu
@onready var q_menu = $Player/Camera2D/QuizPanel
@onready var d_screen = $Player/Camera2D/deathScreen
@onready var player = $Player
signal is_paused

@onready var QuestionText = $Player/Camera2D/QuizPanel/Question_Name
@onready var ListItem = $Player/Camera2D/QuizPanel/ItemList
@onready var corrAns = $Player/Camera2D/QuizPanel/CorrectAns
@onready var okButton = $Player/Camera2D/QuizPanel/okButton
var file_path = str("res://Quiz Files/",FileName.file_name)
var items
var formatted_questions = []
var item: Dictionary
var index_item: int = 0
var correct: bool = false
var choice_made = false
func file_json():
	items = read_json_file(file_path)
	if items != null:
		var questions = items["questions"]
		if questions != null:
			for question_data in questions:
				var formatted_question = {}
				formatted_question["type"] = question_data["type"]
				formatted_question["text"] = question_data["text"]
				formatted_question["options"] = question_data["options"]
				formatted_question["correct_option"] = question_data["correct_option"]
				formatted_questions.append(formatted_question)

func read_json_file(file_path):
	var json_as_text = FileAccess.get_file_as_string(file_path)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict

func quiz_question():
	okButton.hide()
	ListItem.clear()
	corrAns.text = ""
	item = formatted_questions.pick_random()
	QuestionText.text = item["text"]
	var opts = item["options"]
	for opt in opts:
		ListItem.add_item(opt)


func _on_item_list_item_selected(index):
	if choice_made == false:
		choice_made = true
		var correctAns = item["correct_option"]
		if index in correctAns:
			corrAns.text = "Correct!"
			correct = true
			okButton.show()
		else:
			corrAns.text = "Incorrect. The correct answer is " + item.options[item.correct_option[0]]
			okButton.show()
	else:
		ListItem.deselect_all()

func _on_ok_button_pressed():
	choice_made = false
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
	file_json();
	spawner()
	randomize()
	player.hp_zero.connect(_on_hp_zero)
	is_paused.connect(_on_paused)

func spawner():
	var squareMob = preload("res://enemy_1.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	squareMob.global_position = %PathFollow2D.global_position
	add_child(squareMob)

func _on_spawn_timer_timeout():
	spawner()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		is_paused.emit()

func _on_paused():
	pauseMenu()

func _on_hp_zero():
	deathScreen()
	
func deathScreen():
	get_tree().change_scene_to_file("res://death_screen.tscn")
	Engine.time_scale = 0

func pauseMenu():
	if p_menu.visible == true:
		p_menu.hide()
		get_tree().paused = false
	else: 
		p_menu.show()
		get_tree().paused = true

func level_up():
	if get_tree().paused == true:
		q_menu.hide()
		get_tree().paused = false
	else:
		q_menu.show()
		get_tree().paused = true
		quiz_question()
