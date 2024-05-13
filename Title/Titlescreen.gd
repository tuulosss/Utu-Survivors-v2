extends Button


@onready var TitleMusic = $"../TitleMusic"

func _on_pressed():
	get_tree().change_scene_to_file("res://World/world.tscn")
	TitleMusic.stop()

	
func _on_quit_pressed():
	get_tree().quit()
