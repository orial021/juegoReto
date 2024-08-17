extends Node2D

const SPEED = 592
var direction = Vector2.ZERO


func _ready():
	pass
	
	
func _process(delta):
	global_position.x += SPEED * delta * direction.x
	
	
func _on_area_entered(area):
	if area.is_in_group("Enemy"):
		area.damage_ctrl(1)
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.damage_ctrl(1)
		queue_free()
