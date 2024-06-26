extends Area2D

var level =1 
var hp = 999
var speed = 300
var damage = 3
var knockback_amount = 100
var paths = 1
var attack_size = 1.5
var attack_speed = 5.0

var target = Vector2.ZERO
var target_array =[]

var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO
var spr_näp_reg =preload("res://Textures/Items/Weapons/näppis.png")

signal remove_from_array(object)
@onready var player = get_tree().get_first_node_in_group(("player"))
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var AttackTimer = get_node("%AttackTimer")
@onready var changeDirectionTimer = get_node("%ChangeDirection")
@onready var resetPosTimer = get_node("%ResetPosTimer")
@onready var snd_attack = $snd_attack
@onready var PlayerPosTimer = get_node("%PlayerPosTimer")

func _ready():
	update_Näppis()
	_on_reset_pos_timer_timeout()

func update_Näppis():
	level = player.Näppis_level
	match level:
		1:
			hp += 0
			speed += 0
			damage += 2
			knockback_amount += 0
			paths += 0
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1-player.spell_cooldown)
		2:
			hp += 0
			speed += 0
			damage += 2
			knockback_amount += 0
			paths += 1
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1-player.spell_cooldown)
		3:
			hp +=0
			speed += 0
			damage += 0
			knockback_amount += 0
			paths += 1
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1-player.spell_cooldown)
		4:
			hp += 0
			speed += 0
			damage += 5
			knockback_amount += 20
			paths += 0
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1-player.spell_cooldown)
			
	
	scale = Vector2(1.0,1.0) * attack_size
	AttackTimer.wait_time = attack_speed

func _physics_process(delta):
	var new_rotation_degrees = angle.angle() + deg_to_rad(135)
	if target_array.size() > 0:
		position += angle*speed*delta
	else:
		var player_angle = global_position.direction_to(reset_pos)
		var distance_dif = global_position - player.global_position
		var return_speed = 20
		if abs(distance_dif.x) > 500 or abs(distance_dif.y) > 500:
			return_speed = 100
		position += player_angle*return_speed*delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(135)



func add_paths():
	snd_attack.play()
	emit_signal("remove_from_array",self)
	target_array.clear()
	var counter = 0
	while counter < paths:
		var new_path = player.get_random_target()
		target_array.append(new_path)
		counter += 1
	enable_attack(true)
	target = target_array[0]
	process_path()

func process_path():
	angle = global_position.direction_to(target)
	changeDirectionTimer.start()
	PlayerPosTimer.start()
	var tween = create_tween()
	var new_rotation_degrees = angle.angle() + deg_to_rad(135)
	tween.tween_property(self,"rotation",new_rotation_degrees,0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func enable_attack(atk = true):
	if atk:
		collision.call_deferred("set","disabled",false)
		sprite.texture = spr_näp_reg
	else:
		collision.call_deferred("set","disabled",true)
		sprite.texture = spr_näp_reg

func _on_attack_timer_timeout():
	add_paths()

func _on_change_direction_timeout():
	var distance = global_position.distance_to(player.global_position)
	print(distance)
	if distance > 300:
		var tween = create_tween()
		tween.tween_property(self, "position", player.global_position,1.5).set_trans(Tween.TRANS_QUINT).set_ease((Tween.EASE_OUT))
		tween.play()
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			snd_attack.play()
			emit_signal("remove_from_array",self)
		else:
			changeDirectionTimer.stop()
			AttackTimer.start()
			enable_attack(false)
	else:
		changeDirectionTimer.stop()
		AttackTimer.start()
		enable_attack(false)


func _on_reset_pos_timer_timeout():
	var choose_direction = randi() % 4
	reset_pos = player.global_position
	match choose_direction:
		0:
			reset_pos.x += 50
		1:
			reset_pos.x -= 50
		2:
			reset_pos.y += 50
		3:
			reset_pos.y -= 50
		
