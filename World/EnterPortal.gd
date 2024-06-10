extends Area2D
var entered = false
var next_scene_name = ""

func _ready():
	pass
	
func _on_body_entered(player):
	entered = true

func _on_body_exited(player):
	entered = false

func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("UseItem"):
			print("")
			
