extends Node2D

@onready var p_menu = $Player/Camera2D/pause_menu
@onready var q_menu = $Player/Camera2D/QuizPanel
@onready var u_menu = $Player/Camera2D/UpgradePanel
@onready var u_list = $Player/Camera2D/UpgradePanel/upgradelist

@onready var d_screen = $Player/Camera2D/deathScreen
@onready var player = $Player
@onready var wolfMob
@onready var draugrMob
@onready var mageMob
@onready var rand_num
signal is_paused

@onready var QuestionText = $Player/Camera2D/QuizPanel/Question_Name
@onready var ListItem = $Player/Camera2D/QuizPanel/ItemList
@onready var corrAns = $Player/Camera2D/QuizPanel/CorrectAns
@onready var okButton = $Player/Camera2D/QuizPanel/okButton
@onready var xpbar = $Player/expBar
var file_path = str("res://Quiz Files/",Global.file_name)
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

func read_json_file(filepath):
	var json_as_text = FileAccess.get_file_as_string(filepath)
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
		if ListItem.get_item_text(index) == item.options[item.correct_option[0]]:
			corrAns.text = "Correct!"
			correct = true
			okButton.show()
		else:
			corrAns.text = "Incorrect. The correct answer is " + item.options[item.correct_option[0]]
			correct=false
			okButton.show()
	else:
		ListItem.deselect_all()

func _on_ok_button_pressed():
	choice_made = false
	if correct == true:
		correct=false
		level_reward()
	else:
		q_menu.hide()
		xpbar.show()
		get_tree().paused=false

func level_reward():
	q_menu.hide()
	u_list.set_item_text(0, str("Increase Damage by .1 (Current Damage: ",Global.range_atk_dmg,")"))
	u_list.set_item_text(1, str("Increase Attack Speed by .05 (Current Attack Speed: ",Global.range_atk_spd,")"))
	u_list.set_item_text(2, str("Increase Projectile Count by .1 (Current Projectiles: ",Global.range_atk_count,")"))
	u_list.set_item_selectable(0,true)
	u_list.set_item_selectable(1,true)
	u_list.set_item_selectable(2,true)
	$Player/Camera2D/UpgradePanel/dmgButton.text = str("Increase Damage by .2 (Current Damage: ",Global.range_atk_dmg,")")
	$Player/Camera2D/UpgradePanel/spdButton.text = str("Increase Attack Speed by .05 (Current Attack Speed: ",Global.range_atk_spd,")")
	$Player/Camera2D/UpgradePanel/countButton.text = str("Increase Projectile Count by .1 (Current Projectiles: ",snappedf(float((1-(Global.range_atk_count/10.0))),.01),")")
	u_menu.show()
	

func _on_dmg_button_pressed():
	Global.range_atk_dmg=Global.range_atk_dmg+.2;
	u_menu.hide()
	xpbar.show()
	get_tree().paused=false
	

func _on_spd_button_pressed():
	Global.range_atk_spd-=.05;
	u_menu.hide()
	xpbar.show()
	get_tree().paused=false
	

func _on_count_button_pressed():
	Global.range_atk_count-=1;
	u_menu.hide()
	xpbar.show()
	get_tree().paused=false

#func _on_upgradelist_item_selected(index):
	#if index == 1:
		#Global.range_atk_dmg+=.2;
	#elif index == 2:
		#Global.range_atk_spd-=.05;
	#elif index == 3:
		#Global.range_atk_count+=.2;
	#get_tree().paused=false
	#xpbar.show()

func get_rand(arr_length):
	var r = randf_range(0,arr_length);
	return r


func _ready():
	Global.range_atk_dmg = 1
	Global.range_atk_count = 10
	Global.range_range = 3000
	Global.range_atk_spd = .6
	file_json();
	spawner()
	randomize()
	player.hp_zero.connect(_on_hp_zero)
	is_paused.connect(_on_paused)

func spawner():
	wolfMob = preload("res://enemy_1.tscn").instantiate()
	draugrMob = preload("res://enemy_3.tscn").instantiate()
	mageMob = preload("res://enemy_2.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	wolfMob.global_position = %PathFollow2D.global_position
	draugrMob.global_position = %PathFollow2D.global_position
	mageMob.global_position = %PathFollow2D.global_position
	rand_num = randf()
	if rand_num <= 0.7:
		add_child(wolfMob)
	elif rand_num <= 0.9:
		add_child(mageMob)
	else:
		add_child(draugrMob)

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
		xpbar.show()
		get_tree().paused = false
	else:
		q_menu.show()
		get_tree().paused = true
		xpbar.hide()
		quiz_question()






