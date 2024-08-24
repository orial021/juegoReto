extends CharacterBody2D
class_name Player


var is_on_ground : bool = false
var is_climbing : bool = false
var death : bool = false
var shot_spawn : Vector2
var can_shot : bool = true

#facilita el cambio de valores importantes y de importaciones
@export_category("Config")
@export_group("Required references")
@export var gui : CanvasLayer
@export var shoot : PackedScene

@export_group("Motion")
@export var speed : int = 128
@export var gravity : int = 16
@export var jump_force : int = 450

#verifica si el personaje esta en el suelo, muerto, cayendo o no esta escalando, para permitir o bloquear otras funciones
func _process(_delta) -> void:
	is_on_ground = is_on_floor()
	match death:
		true:
			death_ctrl()
			$allien.play("death")
		false:
			motion_ctrl()
	if velocity.y >= 2000:
		gui.game_over()
	if not GLOBAL.can_climb:
		is_climbing = false
		
#controla la llamada a las funciones de saltar, disparar, el sonido de los pasos y hace el llamado al movimiento de la mira
func _input(event):
	if not death and is_on_ground and event.is_action_pressed("ui_accept"):
		jump_ctrl(1)
	if event.is_action_pressed("ui_select"):
		shoot_ctrl()
	if is_on_ground and Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
		$allien/settings/Audio_fstps.play()
	if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		$allien/settings/Audio_fstps.stop()
	if Input.is_action_pressed("ui_focus_next"):
		pass
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				focus("up")
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				focus("down")

#instancia el disparo y le modifica su comportamiento
func shoot_ctrl():
	if can_shot:
		$allien/AnimatedSprite2D.play("fire")
		$allien/settings/audio_fire.play()
		var shoot_instance = shoot.instantiate()
		shoot_instance.global_position = $allien/Marker2D.global_position
		shoot_instance.scale = $shotSpawn.scale
		shoot_instance.rotation = $shotSpawn.rotation
		var direction = (Vector2(cos($shotSpawn.rotation), sin($shotSpawn.rotation))) * $shotSpawn.scale.x
		shoot_instance.direction = direction
		can_shot = false
		get_tree().call_group("Environment", "add_child", shoot_instance)
		$allien/settings/Timer.start()

#funcion de salto
func jump_ctrl(power: float) -> void:
	velocity.y = -jump_force * power
	
#funcion de movimiento, se controla el escalado, girar a los lados y animaciones
func motion_ctrl() -> void:
	#movimiento
	if GLOBAL.can_climb and GLOBAL.get_axis().y != 0:
		climb()
	elif not GLOBAL.get_axis().x == 0:
		$allien.scale.x = GLOBAL.get_axis().x
		$shotSpawn.scale.x = GLOBAL.get_axis().x
	velocity.x = GLOBAL.get_axis().x * speed
	velocity.y += gravity
	move_and_slide()
	
	#animaciones
	match GLOBAL.can_climb and is_climbing:
		false:
			match is_on_ground:
				true:
					if not GLOBAL.get_axis().x == 0:
						$allien.set_animation("walk")
						$allien.play()
					else:
						$allien.set_animation("idle")
				false:
					if velocity.y < 0:
						$allien.set_animation("jump_up")
						$allien/settings/Audio_jump.play()
					else:
						$allien.set_animation("jump_down")
						if is_on_ground:
							pass
		true:
			match GLOBAL.get_axis().x != 0:
				true:
					$allien.play('walk')
				false:
					if GLOBAL.get_axis().y != 0:
						$allien.set_animation("climb")
						$allien.play()
					elif GLOBAL.get_axis().y == 0:
						$allien.stop()
			
#escalado
func climb():
	is_climbing = true
	velocity.y = GLOBAL.get_axis().y * -speed
	move_and_slide()

#control de la mira
func focus(direction : String):
	match $shotSpawn.scale.x == 1:
		true:
			if $shotSpawn.rotation > -1.5 and $shotSpawn.rotation <= 0:
				if direction == "up":
					$allien/AnimatedSprite2D.rotation -= 0.5
					$shotSpawn.rotation -= 0.5
				else:
					$allien/AnimatedSprite2D.rotation += 0.5
					$shotSpawn.rotation += 0.5
				print(str($shotSpawn.rotation))
			else:
				$shotSpawn.rotation = 0
				$allien/AnimatedSprite2D.rotation = 0
		false:
			if $shotSpawn.rotation < 1.5 and $shotSpawn.rotation >= 0:
				if direction == "up":
					$allien/AnimatedSprite2D.rotation += 0.5
					$shotSpawn.rotation += 0.5
				else:
					$allien/AnimatedSprite2D.rotation -= 0.5
					$shotSpawn.rotation -= 0.5
				print(str($shotSpawn.rotation))
			else:
				$shotSpawn.rotation = 0
				$allien/AnimatedSprite2D.rotation = 0
	shot_spawn = $shotSpawn.global_position - $allien/Marker2D.global_position
		
#funcion que controla el daño
func damage_ctrl():
	if GLOBAL.is_invincible == false:
		$allien/settings/Timer2.start()
		$allien/settings/Audio_dmg.play()
		if GLOBAL.health > 0:
			GLOBAL.health -= 1
			var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property($allien, "modulate", Color(0, 0, 0, 0), 0.2)
			tween.tween_property($allien, "modulate", Color(1, 1, 1, 1), 0.2)
			tween.tween_property($allien, "modulate", Color(0, 0, 0, 0), 0.2)
			tween.tween_property($allien, "modulate", Color(1, 1, 1, 1), 0.2)
			tween.tween_property($allien, "modulate", Color(0, 0, 0, 0), 0.2)
			tween.tween_property($allien, "modulate", Color(1, 1, 1, 1), 0.2)
			GLOBAL.is_invincible = true
			$allien/settings/Timer2.start()
			if GLOBAL.health <= 0:
				death = true
				$allien.set_animation("death")
			GLOBAL.update_data()
	
#funcion de muerte
func death_ctrl():
	velocity.x = 0
	velocity.y += gravity
	GLOBAL.update_data()
	GLOBAL.is_invincible = false
	move_and_slide()


func _on_allien_animation_finished():
	if $allien.animation == "death":
		gui.game_over()

#impide realizar mas de un disparo por segundo
func _on_timer_timeout():
	can_shot = true

#impide recibir daño mas de una vez por segundo
func _on_timer_2_timeout():
	GLOBAL.is_invincible = false
