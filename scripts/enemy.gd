extends CharacterBody2D
class_name Enemy


@export_category("Config")

@export_group("Options")
@export var health : int = 1
@export var score : int = 100

@export_group("Motion")
@export var speed : int = 16
@export var gravity : int = 16

var direction : int = -1

func _process(_delta):
	if health > 0:
		motion_ctrl()
		
	
func motion_ctrl() -> void:
	$sprite.scale.x = -direction
	
	if not $sprite/RayCast2D.is_colliding() or is_on_wall():
		direction *= -1
		
	velocity.x = direction * speed
	velocity.y += gravity
	move_and_slide()

func damage_ctrl(damage):
	health -= damage
	if health <= 0:
		$sprite.set_animation("death")
		$sprite.play()
		$Collision.set_deferred("disabled", true)
		gravity = 0
		GLOBAL.score += score
		if GLOBAL.score >= 1000:
			GLOBAL.new_life()
		
func _on_sprite_animation_finished():
	if $sprite.animation == "death":
		GLOBAL.enemy_death = true
		queue_free()


func _on_area_damage_body_entered(body):
	if body is Player and health > 0:
		body.damage_ctrl()
