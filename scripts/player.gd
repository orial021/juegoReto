extends CharacterBody2D
class_name Player

var speed : float = 80
var jump_force : float = -110
var is_on_ground : bool = false
var is_climbing : bool = false


func _process(_delta) -> void:
	is_on_ground = is_on_floor()
	motion_ctrl()
	anim_ctrl()
	if GLOBAL.can_climb == true :
		climb()
	
	
func climb() -> void :
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		is_climbing = true
		velocity.y = GLOBAL.get_axis().y * -speed
		$allien.play("climb")
	else:
		is_climbing = false
		velocity.y = 0

func _physics_process(delta):
	if Input.is_action_pressed("ui_accept") and is_on_ground:
		velocity.y = jump_force
		$allien.play("jump_up")
	if not is_on_ground and not is_climbing:
		velocity.y += GLOBAL.gravity * delta
	move_and_slide()
	
func motion_ctrl() -> void:
	velocity.x = GLOBAL.get_axis().x * speed
	if not is_on_ground :
		velocity.x = velocity.x / 2
	
	
func anim_ctrl():
	if GLOBAL.get_axis().x == 0 and is_on_ground:
		$allien.play("idle")
	elif GLOBAL.get_axis().x > 0 and is_on_ground:
		$allien.flip_h = false
		$allien.play("walk")
	elif GLOBAL.get_axis().x < 0 and is_on_ground:
		$allien.flip_h = true
		$allien.play("walk")
	elif velocity.y < 0 and not is_on_ground:
		$allien.play("jump_up")
	elif velocity.y > 0 and not is_on_ground:
		$allien.play("jump_down")
		if is_on_ground:
			landing()


func landing():
	$allien.play("landing")
	
