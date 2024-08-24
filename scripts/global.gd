extends Node2D

var score : int = 100
var health : int = 2
var user_position = Vector2(93, 557)
var axis : Vector2 = Vector2()
var can_climb : bool = false
var direction = 1
var is_invincible : bool = false
var enemy_death : bool = false
var data = {}
var user_id : String
var username : String
var headers = PackedStringArray()
var host : String = "http://localhost:8000"
var endpointUpdate : String

@onready var httpUpdate = $HTTPUpdate

#prepara los headers para todas las solicitudes del juego, ademas del endpoint 
func _ready():
	endpointUpdate = str(host) + "/user/update/" + user_id
	headers.push_back("Content-Type: application/json")

#funcion que envia el movimiento al personaje desde los input
func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	return axis.normalized() if axis != Vector2() else Vector2()
	
#funcion que genera una nueva vida cada 100 puntos e invoca la funcion de actualizar la base de datos
func new_life():
	score -= 1000
	health += 1
	update_data()

#funcion global para actualizar la base de datos
func update_data():
	if health > 0:
		data = {
			"username" = username,
			"score" = score,
			"health" = health,
			"global_position" = ""
		}
		print(data)
		var json_data = JSON.stringify(GLOBAL.data)
		httpUpdate.request(endpointUpdate, headers, HTTPClient.METHOD_PUT, json_data)
	else:
		health = 2
		score = 0
		data = {
			"username" = username,
			"score" = 0,
			"health" = 2,
			"global_position" = ""
		}
		print(data)
		var json_data = JSON.stringify(GLOBAL.data)
		httpUpdate.request(endpointUpdate, headers, HTTPClient.METHOD_PUT, json_data)


func _on_http_update_request_completed(_result, response_code, _headers, _body):
	print("respuesta: " + str(response_code) )
