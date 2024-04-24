extends CharacterBody2D

var move_spd = 70.0
var hp = 100
signal hp_zero
#xp-variables
var xp = 0
var xp_lvl = 1
var xp_to_lvl = 0
@onready var xpBar = get_node("%expBar")
@onready var levelLabel = get_node("%Label")
@onready var main = $"../"
@onready var sprite = $Sprite2D
@onready var spriteS = $Sprite2DSword
@onready var walk = get_node("walkTimer")
@onready var wg = $watergun
@onready var mRange = $meleeRange/meleeRangeBox
@onready var mTimer = $meleeTimer
@onready var invisS = $Sprite2D2

func _ready():
	set_bar(xp,calc_xp_cap())
	%Label.text = str("Level: ", xp_lvl)
	if Global.melee == true:
		Global.melee_range = 60
		Global.melee_atk_dmg = 2
		Global.melee_atk_spd = 2.3
		mTimer.wait_time = Global.melee_atk_spd
	if Global.ranged == true:
		sprite.visible = true;
		spriteS.visible = false;
		wg.visible = true;
	else:
		sprite.visible = false;
		spriteS.visible = true;
		wg.visible = false;

func _physics_process(delta):
	move()
	var overlap = %playerHurtbox.get_overlapping_bodies()
	if overlap.size()>0:
		hp -= 2 * overlap.size() * delta
		%healthbar.value=hp
		if hp <= 0.0:
			hp_zero.emit()
	if(Global.melee==true):
		invisS.look_at(get_global_mouse_position())
		if %meleeTimer.time_left <= 0:
			%meleeTimer.start()

func _on_melee_timer_timeout():
	slice()

func slice():
	var sliced = preload("res://slice.tscn")
	var new_slice = sliced.instantiate()
	owner.add_child(new_slice)
	new_slice.global_position = %Sprite2D2/meleeSpawn.global_position
	%swing.play()
	new_slice.global_rotation = %Sprite2D2/meleeSpawn.global_rotation

func move():
	var x_move = -Input.get_action_strength("left") + Input.get_action_strength("right")
	var y_move = -Input.get_action_strength("up") + Input.get_action_strength("down")
	var moves = Vector2(x_move,y_move)
	if(Global.ranged==true):
		if moves.x > 0:
			sprite.flip_h=false
		elif moves.x < 0:
			sprite.flip_h=true
		if moves != Vector2.ZERO:
			if walk.is_stopped():
				if sprite.frame >= sprite.hframes-1:
					sprite.frame = 1
				else:
					sprite.frame += 1
				walk.start()
	elif(Global.melee==true):
		if moves.x > 0:
			spriteS.flip_h=false
		elif moves.x < 0:
			spriteS.flip_h=true
		if moves != Vector2.ZERO:
			if walk.is_stopped():
				if spriteS.frame >= spriteS.hframes-1:
					spriteS.frame = 1
				else:
					spriteS.frame += 1
				walk.start()
	velocity = moves.normalized()*move_spd
	move_and_slide()
	

func _on_pickup_range_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calc_xp(gem_exp)

func calc_xp(gem_exp):
	var exp_req = calc_xp_cap()
	xp_to_lvl += gem_exp
	if xp + xp_to_lvl > exp_req:
		xp_to_lvl -= calc_xp_cap()-xp
		xp_lvl += 1
		%Label.text = str("Level: ", xp_lvl)
		xp = 0
		exp_req = calc_xp_cap()
		main.level_up()
		calc_xp(0)
	else:
		xp += xp_to_lvl
		xp_to_lvl = 0
	set_bar(xp,exp_req)

func calc_xp_cap():
	var xp_cap = xp_lvl
	if xp_lvl < 20:
		xp_cap = xp_lvl * 5
	elif xp_lvl < 40:
		xp_cap = xp_lvl * 12.5
	else:
		xp_cap = xp_lvl * 20
	return xp_cap

func set_bar(val = 1, max_val=100):
	%expBar.value = val
	%expBar.max_value = max_val

