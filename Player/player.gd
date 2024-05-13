extends CharacterBody2D

#musiikki
@onready var GameMusic = $GameMusic

#pelaajan stats ja movement
@export var movement_speed = 100
var hp=2
var experience = 0
var experience_level = 1
var collected_experience = 0
var last_movement = Vector2.UP

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


#HTTP
var HTTP_ammo = 0
var HTTP_baseammo = 1
var HTTP_attackspeed = 2
var HTTP_level = 0

#Matrix
var Matrix_ammo = 100
var Matrix_baseammo = 1
var Matrix_attackspeed = 3
var Matrix_level = 0

#Näppis
var Näppis_ammo = 1
var Näppis_level = 1

#Vihu
var enemy_close = []

func _ready():
	attack()
	set_expbar(experience, calculate_experiencecap())

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
		
	velocity = mov.normalized()*movement_speed
	move_and_slide()

#HTTP Hyökkäys
func attack():
	if HTTP_level > 0:
		HötöTimer.wait_time = HTTP_attackspeed
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
	HTTP_ammo += HTTP_baseammo
	HötöAttackTimer.start()
	print("start")
	
func _on_hötöattack_timer_timeout():
	if HTTP_ammo > 0:
		print("shoot")
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
	Matrix_ammo += Matrix_baseammo
	MatrixAttackTimer.start()
func _on_matrix_timer_timeout():
	if Matrix_ammo > 0:
		print("test")
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
	var calc_spawns =Näppis_ammo - get_Näppis_total
	while calc_spawns > 0:
		var Näppis_spawn = Näppis.instantiate()
		Näppis_spawn.global_position = global_position
		NäppisBase.add_child(Näppis_spawn)
		calc_spawns -= 1
		
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


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)
	
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
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused=true
	

func upgrade_character(upgrade):
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	
	var tween = levelPanel.create_tween()
	get_tree().paused = false
	tween.tween_property(levelPanel, "position", Vector2(390,-500),0.4).set_trans(Tween.TRANS_QUINT).set_ease((Tween.EASE_IN))
	tween.play() 
	levelPanel.visible=false
	
	calculate_experience(0)
	pass
	
