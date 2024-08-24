extends CharacterBody2D
class_name Enemy

# Categoría de exportación para la configuración
@export_category("Config")

# Grupo de exportación para opciones
@export_group("Options")
@export var health : int = 1
@export var score : int = 100


# Grupo de exportación para movimiento
@export_group("Motion")
@export var speed : int = 16
@export var gravity : int = 16


# Dirección inicial del enemigo
var direction : int = -1


# Controla el movimiento del enemigo si tiene salud
func _process(_delta):
	if health > 0:
		motion_ctrl()
		
# Controla el movimiento del enemigo	
func motion_ctrl() -> void:
	$sprite.scale.x = -direction
	
	# Cambia la dirección si no está colisionando o está en una pared
	if not $sprite/RayCast2D.is_colliding() or is_on_wall():
		direction *= -1
		
	velocity.x = direction * speed
	velocity.y += gravity
	move_and_slide()

# Controla el daño recibido por el enemigo
func damage_ctrl(damage):
	health -= damage
	$Settings/AudioHit.play()
	if health <= 0:
		$sprite.set_animation("death")
		$sprite.play()
		$Collision.set_deferred("disabled", true)
		gravity = 0
		GLOBAL.score += score
		if GLOBAL.score >= 1000:
			GLOBAL.new_life()
	GLOBAL.update_data()
		
# Controla la animacion de la muerte del enemigo
func _on_sprite_animation_finished():
	if $sprite.animation == "death":
		GLOBAL.enemy_death = true
		queue_free()

# en caso de que algun componente de la clase player entre al area, activa el damage_ctrl() de dicho componente
func _on_area_damage_body_entered(body):
	if body is Player and health > 0:
		body.damage_ctrl()
