extends Node2D

var score : int = 100
var health : int = 2
var user_position = Vector2(93, 557)
var axis : Vector2 = Vector2()
var can_climb : bool = false
var direction = 1
var enemy_death : bool = false
var data = {}
var user_id : String
var username : String
var headers = PackedStringArray()
var host : String = "http://localhost:8000"
#"https://206.189.176.123:7500"
#"http://localhost:8000"
var endpointUpdate : String

@onready var httpUpdate = $HTTPUpdate


func _ready():
	endpointUpdate = str(host) + "/user/update/" + username
	headers.push_back("Content-Type: application/json")

func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	return axis.normalized() if axis != Vector2() else Vector2()
	
func _input(_event):
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		direction = get_axis().x


func new_life():
	score -= 1000
	health += 1
	update_data()

func update_data():
	if health > 0:
		data = {
			"username" = username,
			"score" = score,
			"health" = health,
			"global_position" = user_position
		}
		print(data)
		var json_data = JSON.stringify(GLOBAL.data)
		httpUpdate.request(endpointUpdate, headers, HTTPClient.METHOD_PUT, json_data)
	else:
		data = {
			"username" = username,
			"score" = 0,
			"health" = 2,
			"global_position" = user_position
		}
		print(data)
		var json_data = JSON.stringify(GLOBAL.data)
		httpUpdate.request(endpointUpdate, headers, HTTPClient.METHOD_PUT, json_data)


func _on_http_update_request_completed(_result, response_code, _headers, _body):
	print("respuesta: " + str(response_code) )
