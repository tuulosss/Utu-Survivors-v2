#Matrix hyökkäyksen koodi

extends Area2D


var level = 1 
var hp = 9999
var speed = 100
var damage =3
var knockback_amount = 100
var attack_size = 1.0


var last_movement = Vector2.ZERO
var angle = Vector2.ZERO
var angle_less = Vector2.ZERO
var angle_more = Vector2.ZERO

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	match level:
		1: 
			hp = 9999
			speed = 100
			damage =3
			knockback_amount = 100
			attack_size = 1.0

	var move_to_less = Vector2.ZERO
	var move_to_more = Vector2.ZERO
	match last_movement:
			Vector2.UP, Vector2.DOWN:
				move_to_less = global_position + Vector2(randf_range(-1,-0.25),last_movement.y)*500
				move_to_more = global_position + Vector2(randf_range(0.25,1),last_movement.y)*500
			Vector2.LEFT, Vector2.RIGHT:
				move_to_less = global_position + Vector2(last_movement.x,randf_range(-1,-0.25))*500
				move_to_more = global_position + Vector2(last_movement.y ,randf_range(0.25,1))*500
			Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,-1):
				move_to_less = global_position + Vector2(last_movement.x, last_movement.y)*500
				move_to_more = global_position + Vector2(last_movement.x * randf_range(0,0.75), last_movement.y)*500
				
	angle_less = global_position.direction_to(move_to_less)
	angle_more = global_position.direction_to(move_to_more)
	
	var tween = create_tween()
	var set_angle = randi_range(0,1)
	if set_angle == 1:
		tween.tween_property(self,"angle",angle_more,2)
		tween.tween_property(self,"angle",angle_less,2)
		tween.tween_property(self,"angle",angle_more,2)
		tween.tween_property(self,"angle",angle_less,2)
		tween.tween_property(self,"angle",angle_more,2)
		tween.tween_property(self,"angle",angle_less,2)
	else:
		angle = angle_more
		tween.tween_property(self,"angle",angle_less,2)
		tween.tween_property(self,"angle",angle_more,2)
		tween.tween_property(self,"angle",angle_less,2)
		tween.tween_property(self,"angle",angle_more,2)
		tween.tween_property(self,"angle",angle_less,2)
		tween.tween_property(self,"angle",angle_more,2)
	tween.play()
	
func _physics_process(delta):
	position += angle*speed*delta
	
func _on_timer_timeout():
	emit_signal("remove_from_array")
	queue_free()
