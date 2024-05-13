extends CharacterBody2D


#musiikki
@onready var GameMusic = $GameMusic

#pelaajan movement
@export var movement_speed = 100
var hp=2
var last_movement = Vector2.UP

#Hyökkäykset
var HTTP =preload("res:///Player/Attack/jääpuikko.tscn")
var Matrix =preload("res://Player/Attack/Matrix.tscn")

#HyökkäysNodet
@onready var HötöTimer = get_node("%HötöTimer")
@onready var HötöAttackTimer = get_node("%HötöAttackTimer")
@onready var MatrixTimer = get_node("%MatrixTimer")
@onready var MatrixAttackTimer = get_node("%MatrixAttackTimer")

#HTTP
var HTTP_ammo = 0
var HTTP_baseammo = 1
var HTTP_attackspeed = 4
var HTTP_level = 0

#Matrix
var Matrix_ammo = 0
var Matrix_baseammo = 1
var Matrix_attackspeed = 3
var Matrix_level = 1

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
			
			
func _on_matrix_attack_timer_timeout():
	print("attacktimeout")
	Matrix_ammo += Matrix_baseammo
	MatrixAttackTimer.start()

func _on_matrix_timer_timeout():
	print("matrixtimer")
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


func _on_hurt_box_hurt(damage):
	hp-=damage
	print(hp)
	if hp <= 0:
		get_tree().change_scene_to_file("res://Title/GameOver.tscn")
		
		



