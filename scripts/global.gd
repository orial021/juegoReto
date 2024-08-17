extends Node2D

var score : int = 100
var health : int = 2
var axis : Vector2 = Vector2()
var can_climb : bool = false
var direction : int = 1
var enemy_death : bool = false


func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	return axis.normalized() if axis != Vector2() else Vector2()
	
func _input(event):
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		direction = get_axis().x


func new_life():
	score -= 1000
	health += 1

	
