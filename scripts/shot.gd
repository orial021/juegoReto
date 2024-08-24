extends Node2D

const SPEED = 592
var direction = Vector2.ZERO


#genera el movimiento de la bala
func _process(delta):
	global_position += SPEED * delta * direction
	
#interactua con el enemigo al entrar en su area
func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.damage_ctrl(1)
		queue_free()

#desaparece si sale de la pantalla visible
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


