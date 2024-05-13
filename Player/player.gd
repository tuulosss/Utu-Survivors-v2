extends CharacterBody2D
@export var movement_speed =100
var hp=80

#Hyökkäykset
var HTTP =preload("res:///Player/Attack/jääpuikko.tscn")

#HyökkäysNodet
@onready var HötöTimer = get_node("%HötöTimer")
@onready var HötöAttackTimer = get_node("%HötöAttackTimer")

#HTTP
var HTTP_ammo = 0
var HTTP_baseammo = 1
var HTTP_attackspeed = 2
var HTTP_level = 1

#Vihu
var enemy_close = []

func _ready():
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




func _on_hurt_box_2_hurt(damage):
	hp-=damage
	print("Damage taken!, current hp: ",hp)
