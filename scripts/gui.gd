extends CanvasLayer

#deshabilita los botones de reinicio y salir para no ser presionados por accidente
func _ready():
	$GameOver/VBoxContainer/buttons/restart.disabled = true
	$GameOver/VBoxContainer/buttons/exit.disabled = true
	
#mantiene actualizado la interfaz
func _process(_delta):
	$HBoxContainer/health.text = "SALUD: " + str(GLOBAL.health)
	$HBoxContainer/score.text = "SCORE: " + str(GLOBAL.score)
	$HBoxContainer/username.text = str(GLOBAL.username)
	
#funcion llamada al perder todas las vidas, pausa el juego, habilita y muestra los botones de reinicio y salir
func game_over() -> void:
	get_tree().paused = true
	$GameOver/VBoxContainer/buttons/restart.disabled = false
	$GameOver/VBoxContainer/buttons/exit.disabled = false
	$GameOver/VBoxContainer/buttons/restart.grab_focus()
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($GameOver, "modulate", Color(1, 1, 1, 0.8), 1.0)
	
#al usar el boton de reinicio vuelve a cargar la escena principal y reinicia los valores de las variables globales
func _on_restart_pressed():
	GLOBAL.score = 0
	GLOBAL.health = 2
	get_tree().change_scene_to_file("res://scenes/environment.tscn")

#cierra el juego
func _on_exit_pressed():
	get_tree().quit()
