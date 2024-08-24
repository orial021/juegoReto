extends Control

var username : String
var data = {}
var endpoint : String
var json = JSON.new()
@onready var httpCreate = $Node/HTTPCreate
@onready var httpShow = $Node/HTTPShow

#hace focus en el lineedit para poder escribir en el momento de empezar el juego, inicia musica
func _ready():
	$ColorRect/username.grab_focus()
	$Node/AudioBackground.play()
	
#el boton inicio envia el username al api, si el username esta vacio abre el juego sin buscar informacion
#si el username no existe en la base de datos crea uno nuevo
func _on_start_pressed():
	username = $ColorRect/username.text
	if $ColorRect/username.text == "":
		get_tree().change_scene_to_file("res://scenes/environment.tscn")
	if $ColorRect/username.text != "" :
		data = {
		"username": username
		}
		endpoint = str(GLOBAL.host) + "/user/show_by_user/" + username
		httpShow.request(endpoint, GLOBAL.headers, HTTPClient.METHOD_GET)
	
#cierra el juego
func _on_exit_pressed():
	get_tree().quit()

#funcion de retorno en caso de que el username exista en la base de datos, guarda la informacion del user en variables globales
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
			greetings()
	elif response_code == 404:
		GLOBAL.username = username
		data = {
		"username": username,
		"score": "0",
		"health": "2",
		"global_position": ""
		
		}
		endpoint = str(GLOBAL.host) + "/user/create"
		var json_data = JSON.stringify(data)
		httpCreate.request(endpoint, GLOBAL.headers, HTTPClient.METHOD_POST, json_data)

#saludo al user
func greetings():
	GLOBAL.endpointUpdate = str(GLOBAL.host) + "/user/update/" + GLOBAL.user_id
	$ColorRect/greetings.text = "hola " + GLOBAL.username + " bienvenido al juego"
	$Node/Timer.start()
	
#espera 3 segundos antes de entrar al juego para que se pueda leer el saludo
func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/environment.tscn")

#funcion usada en caso de que el username no exista en la base de datos, crea un nuevo user y actualiza las variables globales
func _on_http_create_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var body_parsed = json.parse(body_string)
		if body_parsed == OK:
			data = json.get_data()
			GLOBAL.username = data["username"]
			GLOBAL.user_id = data["id"]
			GLOBAL.update_data()
			greetings()
	else:
		$ColorRect/greetings.visible = true
		$ColorRect/greetings.text = "Ocurrio un error"

