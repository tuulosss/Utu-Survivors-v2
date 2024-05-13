extends Area2D

#hyökkäyksen statit
var level = 1 
var hp = 1
var speed = 100
var damage =3
var knock_amount = 100
var attack_size = 1.0

var target =Vector2.ZERO
var angle = Vector2.ZERO


var player = null


var _smoothed_mouse_pos: Vector2 

#@onready var player = get_tree().get_first_node_in_group("player") 

func _ready():
	angle = global_position.direction_to(get_global_mouse_position())
	#angle = global_position.direction_to(target)
	match level:
		1: 
			hp = 1
			speed = 100
			damage = 2
			knock_amount = 100
			attack_size = 1.0
			
			
func _physics_process(delta):
	position += angle*speed*delta
	
func enemy_hit(charge = 1):
	hp -= charge
	if hp < 0:
		queue_free()


func _on_timer_timeout():
	queue_free()
