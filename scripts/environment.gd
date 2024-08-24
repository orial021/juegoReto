extends Node2D

var moving = 0
var endpoint
var data = {}
var json = JSON.new()
@export var enemy : PackedScene
@onready var httpShow = $HTTPShow

#en caso de que el juego inicie desde un reinicio por muerte, levanta la pausa
#genera las variables necesarias para hacer la peticiones al server y extraer la informacion del usuario, es un paso de seguridad
func _ready():
	get_tree().paused = false
	GLOBAL.can_climb = false
	endpoint = str(GLOBAL.host) + "/user/show/" + str(GLOBAL.user_id)
	httpShow.request(endpoint, GLOBAL.headers, HTTPClient.METHOD_GET)
	
#ejecuta la funcion parallax para el fondo y el path para el respawn de los enemigos
func _process(delta) -> void:
	parallax_bg(delta)
	$Node2D/Path2D/PathFollow2D.set_progress($Node2D/Path2D/PathFollow2D.get_progress() + 80 * delta)
	
#coordina el paralaje de las nubes y el cielo
func parallax_bg(delta_time) -> void:
	$sky.scroll_base_offset -= Vector2(1, 0) * 40 * delta_time
	$far_cloud.scroll_base_offset -= Vector2(1, 0) * 80 * delta_time
	$near_cloud.scroll_base_offset -= Vector2(1, 0) * 120 * delta_time

#habilita la funcion de escalar
func _on_first_body_entered(body):
	if body is Player:
		GLOBAL.can_climb = true
		
#deshabilita la funcion de escalar
func _on_first_body_exited(body):
	if body is Player:
		GLOBAL.can_climb = false

#instancia un nuevo enemigo cada vez que alguno muere, con un respawn de 1 segundo
func _on_timer_enemy_timeout():
	if GLOBAL.enemy_death:
		var enemy_instance = enemy.instantiate()
		enemy_instance.global_position = $Node2D/Path2D/PathFollow2D.global_position
		add_child(enemy_instance)
		GLOBAL.enemy_death = false

#actualiza la informacion del ususario en las variables globales
func _on_http_show_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var body_parsed = json.parse(body_string)
		if body_parsed == OK:
			data = json.get_data()
			GLOBAL.user_id = data["id"]
			GLOBAL.username = data["username"]
			GLOBAL.health = data["health"]
			GLOBAL.score = data["score"]

#desaparece las instrucciones de juego en el momento en que se aleja del rango de la camara
func _on_visible_on_screen_notifier_2d_screen_exited():
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($TextureRect, "modulate", Color(0, 0, 0, 0), 1.0)
