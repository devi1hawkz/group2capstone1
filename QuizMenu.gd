extends Control
@onready var ListItem = $ItemList
@onready var dir = DirAccess.open("res://Quiz Files")
@onready var items = dir.get_files()
@onready var select = $Selected
# Called when the node enters the scene tree for the first time.
func _ready():
	quiz_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	
func quiz_display():
	for i in items.size():
		ListItem.add_item(items[i])
	if(Global.file_name!=null):
		select.text = ("Current Selected File: " + Global.file_name)


func _on_item_list_item_selected(index):
	Global.file_name = items[index]
	select.text = ("Current Selected File: " + Global.file_name)
