extends Area2D

@export var knockback_amount = 1000
@export var damage = 0
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHitBoxTimer

func tempdisable():
	collision.call_deferred("set","disabled",true)
	disableTimer.start()

func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set","disabled",false)
