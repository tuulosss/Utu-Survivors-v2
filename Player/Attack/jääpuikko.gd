extends Area2D

#hyökkäyksen statit
@export var level = 1 
@export var hp = 1
@export var speed = 90
@export var damage = 4
@export var knockback_amount = 90
@export var attack_size = 1.0

var target =Vector2.ZERO
var angle = Vector2.ZERO
@onready var player = get_tree().get_first_node_in_group("player")
var _smoothed_mouse_pos: Vector2 

signal remove_from_array(object)
#@onready var player = get_tree().get_first_node_in_group("player") 

func _ready():
	$Snd_play.play()
	angle = global_position.direction_to(get_global_mouse_position())
	#angle = global_position.direction_to(target)
	match level:
		1: 
			hp += 1
			speed *= 1.25
			damage += 0
			knockback_amount += 10
			attack_size = 1.0 * (1 + player.spell_size)
		2: 
			hp += 0
			speed += 0
			damage += 0
			knockback_amount += 0
			attack_size = 1.0 * (1 + player.spell_size)
		3: 
			hp +=1
			speed += 0
			damage *= 1.20
			knockback_amount += 0
			attack_size = 1.0 * (1 + player.spell_size)
		4: 
			hp += 0
			speed += 0
			damage += 0
			knockback_amount += 0
			attack_size = 1.0 * (1 + player.spell_size)
	
	scale =Vector2(1.0,1.0)* attack_size
	#var tween = create_tween()
	#tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).SET
	#tween.play()
	#
func _physics_process(delta):
	position += angle*speed*delta
	var tween = create_tween()
	var new_rotation_degrees = deg_to_rad(1000)
	tween.tween_property(self,"rotation",new_rotation_degrees,10).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func enemy_hit(charge = 1):
	hp -= charge
	if hp < 0:
		emit_signal("remove_from_array",self)
		queue_free()

func _on_timer_timeout():
	emit_signal("remove_from_array",self)
	queue_free()
