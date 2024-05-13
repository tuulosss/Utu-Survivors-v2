extends Control


@onready var GameOverMusic = $Over
func _on_quit_pressed():
	get_tree().quit()
	
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Title/titleScreen.tscn")
	GameOverMusic.stop()
