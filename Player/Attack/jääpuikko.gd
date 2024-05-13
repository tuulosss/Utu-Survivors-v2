extends Area2D

#hyökkäyksen statit
var level = 1 
var hp = 1
var speed = 100
var damage =3
var knockback_amount = 100
var attack_size = 1.0

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
			hp = 1
			speed = 100
			damage = 3
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2: 
			hp = 1
			speed = 100
			damage = 3
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3: 
			hp = 2
			speed = 100
			damage = 6
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		4: 
			hp = 1
			speed = 100
			damage = 6
			knockback_amount = 100
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
