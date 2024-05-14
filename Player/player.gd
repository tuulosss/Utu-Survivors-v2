extends CharacterBody2D


#musiikki
@onready var GameMusic = $GameMusic

@export var movement_speed =100
var hp=2

#Hyökkäykset
var HTTP =preload("res:///Player/Attack/jääpuikko.tscn")

#HyökkäysNodet
@onready var HötöTimer = get_node("%HötöTimer")
@onready var HötöAttackTimer = get_node("%HötöAttackTimer")

#HTTP
var HTTP_ammo = 0
var HTTP_baseammo = 1
var HTTP_attackspeed = 4
var HTTP_level = 1

#Vihu
var enemy_close = []

func _ready():
	GameMusic.play()
	attack()

func _physics_process(delta):
	movement()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if x_mov == 1:
		$Sprite2D.flip_h = true;
	elif x_mov == -1:
		$Sprite2D.flip_h = false;
	velocity = mov.normalized()*movement_speed
	move_and_slide()


#HTTP Hyökkäys
func attack():
	
	if HTTP_level > 0:
		HötöTimer.wait_time = HTTP_attackspeed
		if HötöTimer.is_stopped():
			HötöTimer.start()

#Attack Timer
func _on_hötötimer_timeout():
	HTTP_ammo += HTTP_baseammo
	HötöAttackTimer.start()
func _on_hötöattack_timer_timeout():
	if HTTP_ammo > 0:
		var HTTP_attack = HTTP.instantiate()
		HTTP_attack.position = position
		var target = get_random_target()
		HTTP_attack.target = target
		HTTP_attack.look_at(target)
		HTTP_attack.level = HTTP_level
		add_child(HTTP_attack)
		HTTP_ammo -= 1
		if HTTP_ammo > 0:
			HötöAttackTimer.start()
		else:
			HötöAttackTimer.stop()
	
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


func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp-=damage
	print(hp)
	if hp <= 0:
		get_tree().change_scene_to_file("res://Title/GameOver.tscn")
		
<<<<<<< Updated upstream
		
=======
	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level <40:
		exp_cap+95*(experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
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
			HTTP_baseammo += 1
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
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,maxhp)
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
	
>>>>>>> Stashed changes
