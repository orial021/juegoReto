extends Node2D

var moving = 0
@export var enemy : PackedScene

func _ready():
	get_tree().paused = false
	GLOBAL.score = 0
	GLOBAL.health = 2
	GLOBAL.can_climb = false
	

func _process(delta) -> void:
	parallax_bg(delta)
	$Node2D/Path2D/PathFollow2D.set_progress($Node2D/Path2D/PathFollow2D.get_progress() + 80 * delta)
	
	
func parallax_bg(delta_time) -> void:
	$sky.scroll_base_offset -= Vector2(1, 0) * 40 * delta_time
	$far_cloud.scroll_base_offset -= Vector2(1, 0) * 80 * delta_time
	$near_cloud.scroll_base_offset -= Vector2(1, 0) * 120 * delta_time

func _on_first_body_entered(body):
	if body is Player:
		print("entro a la escalera")
		GLOBAL.can_climb = true

func _on_first_body_exited(body):
	if body is Player:
		print("salio de la escalera")
		GLOBAL.can_climb = false


func _on_timer_enemy_timeout():
	if GLOBAL.enemy_death:
		var enemy_instance = enemy.instantiate()
		enemy_instance.global_position = $Node2D/Path2D/PathFollow2D.global_position
		add_child(enemy_instance)
		GLOBAL.enemy_death = false
