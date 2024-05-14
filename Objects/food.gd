extends Area2D

@export var heal = 20

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_collected

		
func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 3*delta
		
func collect():
	sound.play()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	return heal


func _on_snd_collected_finished():
	queue_free()
