extends CharacterBody2D

#musiikki
@onready var GameMusic = $GameMusic
#pelaajan stats ja movement
@export var movement_speed = 100
var maxhp=100000
var hp=maxhp
var experience = 0
var experience_level = 1
var collected_experience = 0
var last_movement = Vector2.UP
var knockback = Vector2.ZERO
var target =Vector2.ZERO
var angle = Vector2.ZERO
@export var knockback_amount = 100
#Hyökkäykset
var HTTP =preload("res:///Player/Attack/jääpuikko.tscn")
var Matrix =preload("res://Player/Attack/Matrix.tscn")
var Näppis = preload("res://Player/Attack/näppis.tscn")

#HyökkäysNodet
@onready var HötöTimer = get_node("%HötöTimer")
@onready var HötöAttackTimer = get_node("%HötöAttackTimer")
@onready var MatrixTimer = get_node("%MatrixTimer")
@onready var MatrixAttackTimer = get_node("%MatrixAttackTimer")
@onready var NäppisBase = get_node("%NäppisBase")
#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var sndLevelUp = get_node("%snd_levelup")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var healthBar = get_node("%HealthBar")

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0 
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#HTTP
var HTTP_ammo = 0
var HTTP_baseammo = 1
var HTTP_attackspeed = 2
var HTTP_level = 1

#Matrix
var Matrix_ammo = 99999
var Matrix_baseammo = 1
var Matrix_attackspeed = 3
var Matrix_level = 0

#Näppis
var Näppis_ammo = 1
var Näppis_level = 0

#Vihu
var enemy_close = []

func _ready():
	GameMusic.play()
	attack()
	set_expbar(experience, calculate_experiencecap())
	_on_hurt_box_hurt(0,0,0)

func _physics_process(_delta):
	movement()



func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if x_mov == 1:
		$Sprite2D.flip_h = true;
	elif x_mov == -1:
		$Sprite2D.flip_h = false;
		
	if mov != Vector2.ZERO:
		last_movement = mov
	knockback = knockback.move_toward(Vector2.ZERO,3)
	velocity = mov.normalized()*movement_speed
	move_and_slide()

#HTTP Hyökkäys
func attack():
	if HTTP_level > 0:
		HötöTimer.wait_time = HTTP_attackspeed * (1-spell_cooldown)
		if HötöTimer.is_stopped():
			HötöTimer.start()
			
	if Matrix_level > 0:
		MatrixTimer.wait_time = Matrix_attackspeed
		if MatrixTimer.is_stopped():
			MatrixTimer.start()
			
	if Näppis_level > 0:
		spawn_Näppis()
#Attack Timer
func _on_hötötimer_timeout():
	HTTP_ammo += HTTP_baseammo + additional_attacks
	HötöAttackTimer.start()
	
func _on_hötöattack_timer_timeout():
	if HTTP_ammo > 0:
		var HTTP_attack = HTTP.instantiate()
		HTTP_attack.position = position
		HTTP_attack.target = get_random_target()
		HTTP_attack.level = HTTP_level
		add_child(HTTP_attack)
		HTTP_ammo -= 1
		if HTTP_ammo > 0:
			HötöAttackTimer.start()
		else:
			HötöAttackTimer.stop()
			
			
func _on_matrix_attack_timer_timeout():
	Matrix_ammo += Matrix_baseammo + additional_attacks
	MatrixAttackTimer.start()
func _on_matrix_timer_timeout():
	if Matrix_ammo > 0:
		var Matrix_attack = Matrix.instantiate()
		Matrix_attack.position = position
		Matrix_attack.last_movement = last_movement
		Matrix_attack.level = Matrix_level
		add_child(Matrix_attack)
		Matrix_ammo -= 1
		if Matrix_ammo > 0:
			MatrixAttackTimer.start()
		else:
			MatrixAttackTimer.stop()
			
func spawn_Näppis():
	var get_Näppis_total = NäppisBase.get_child_count()
	var calc_spawns =(Näppis_ammo + additional_attacks) - get_Näppis_total
	while calc_spawns > 0:
		var Näppis_spawn = Näppis.instantiate()
		Näppis_spawn.global_position = global_position
		NäppisBase.add_child(Näppis_spawn)
		calc_spawns -= 1
	#Upgrade Javelin
	var get_näppikset = NäppisBase.get_children()
	for i in get_näppikset:
		if i.has_method("update_Näppis"):
			i.update_Näppis()
			
	
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if  enemy_close.has(body):
		enemy_close.erase(body)

func _on_hurt_box_hurt(damage, _angle, _knockback_amount):
	hp-= clamp(damage-armor, 1.0, 999)
	#knockback = angle * knockback_amount
	healthBar.max_value =maxhp
	healthBar.value = hp
	if hp <= 0:
		get_tree().change_scene_to_file("res://Title/GameOver.tscn")


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		if area.is_in_group("exp"):
			var gem_exp = area.collect()
			calculate_experience(gem_exp)
		elif area.is_in_group("food"):
			var heal = area.collect()
			hp += heal
			hp = clamp(hp,0,maxhp)
			healthBar.max_value =maxhp
			healthBar.value = hp
			
	
func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience+=gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelUp()

	else:
		experience+= collected_experience
		collected_experience = 0
		
	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 10:
		exp_cap = experience_level*5
	elif experience_level <20:
		exp_cap = 100 + experience_level*10
	else:
		exp_cap = 255 + experience_level*12
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func levelUp():
	sndLevelUp.play()
	lblLevel.text = str("Level: ", experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel, "position", Vector2(390,76),0.4).set_trans(Tween.TRANS_QUINT).set_ease((Tween.EASE_IN))
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused=true
	

func upgrade_character(upgrade):
	match upgrade:
		"HTTPattack1":
			HTTP_level = 1
			HTTP_baseammo += 0
		"HTTPattack2":
			HTTP_level = 2
			HTTP_baseammo += 1
		"HTTPattack3":
			HTTP_level = 3
		"HTTPattack4":
			HTTP_level = 4
			HTTP_baseammo += 2
		"matrix1":
			Matrix_level = 1
			Matrix_baseammo += 1
		"matrix2":
			Matrix_level = 2
			Matrix_baseammo += 1
		"matrix3":
			Matrix_level = 3
			Matrix_attackspeed -= 0.5
		"matrix4":
			Matrix_level = 4
			Matrix_baseammo += 1
		"NÄPPIS1":
			Näppis_level = 1
			Näppis_ammo = 1
		"NÄPPIS2":
			Näppis_level = 2
		"NÄPPIS3":
			Näppis_level = 3
		"NÄPPIS4":
			Näppis_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 2
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.15
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.10
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,maxhp)
			healthBar.max_value =maxhp
			healthBar.value = hp
	attack()
	
	
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible=false
	levelPanel.position = Vector2(390,-500)
	get_tree().paused = false
	calculate_experience(0)
	pass
	
func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #Find already collected upgrades
			pass
		elif i in upgrade_options: #If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #check for prerequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null
