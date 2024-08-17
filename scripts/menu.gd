extends Control

func _ready():
	$VBoxContainer/start.grab_focus()
	
	

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/environment.tscn")
	



func _on_exit_pressed():
	get_tree().quit()
