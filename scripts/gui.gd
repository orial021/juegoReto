extends CanvasLayer

	
func _process(_delta):
	$health.text = "SALUD: " + str(GLOBAL.health)
	$score.text = "SCORE: " + str(GLOBAL.score)
	

func game_over() -> void:
	get_tree().paused = true
	$GameOver/VBoxContainer/buttons/restart.grab_focus()
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($GameOver, "modulate", Color(1, 1, 1, 0.8), 1.0)
	
	
func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_exit_pressed():
	get_tree().quit()
