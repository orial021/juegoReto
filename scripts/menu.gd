extends Control


var username : String
var data = {}
var endpoint : String
var json = JSON.new()
@onready var httpCreate = $Node/HTTPCreate
@onready var httpShow = $Node/HTTPShow


func _ready():
	$ColorRect/username.grab_focus()
	$ColorRect/greetings.visible = false
	$Node/AudioBackground.play()
	# Ruta del archivo por lotes
	var file_path = "start_api.bat"
	var output_file_path = "output.txt"
	

	# Ejecutar el archivo por lotes
	var output = []
	var error = []
	#var result = OS.execute("cmd.exe", ["/c", file_path + " > " + output_file_path + " 2>&1"], output, true, true)

	#print("Result: ", result)
	
	# Leer el contenido del archivo de salida
	'''if FileAccess.file_exists(output_file_path):
		var file = FileAccess.open(output_file_path, FileAccess.READ)
		if file:
			var output_content = file.get_as_text()
			print("Output Content:\n", output_content)
			file.close()
		else:
			print("Error al abrir el archivo de salida.")
	else:
		print("El archivo de salida no existe.")'''

	

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
	

func _on_exit_pressed():
	get_tree().quit()


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
			GLOBAL.user_position = data["global_position"]
			
			greetings()
	elif response_code == 404:
		data = {
		"username": username,
		"score": "0",
		"health": "2",
		"global_position": GLOBAL.user_position
		
		}
		endpoint = str(GLOBAL.host) + "/user/create"
		var json_data = JSON.stringify(data)
		httpCreate.request(endpoint, GLOBAL.headers, HTTPClient.METHOD_POST, json_data)

func greetings():
	GLOBAL.endpointUpdate = str(GLOBAL.host) + "/user/update/" + GLOBAL.user_id
	$ColorRect/greetings.visible = true
	$ColorRect/greetings.text = "hola " + GLOBAL.username + " bienvenido al juego"
	$Node/Timer.start()
	
func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/environment.tscn")


func _on_http_create_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var body_parsed = json.parse(body_string)
		if body_parsed == OK:
			data = json.get_data()
			GLOBAL.update_data()
			GLOBAL.username = data["username"]
			greetings()
	else:
		
		$ColorRect/greetings.visible = true
		$ColorRect/greetings.text = "Ocurrio un error"



