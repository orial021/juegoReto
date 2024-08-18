extends Node2D

var moving = 0
@export var enemy : PackedScene

func _ready():
	get_tree().paused = false
	GLOBAL.can_climb = false
	$Player.global_position = parse_vector2(GLOBAL.user_position)
	
	

func _process(delta) -> void:
	GLOBAL.user_position = $Player.global_position
	parallax_bg(delta)
	$Node2D/Path2D/PathFollow2D.set_progress($Node2D/Path2D/PathFollow2D.get_progress() + 80 * delta)
	
	
func parallax_bg(delta_time) -> void:
	$sky.scroll_base_offset -= Vector2(1, 0) * 40 * delta_time
	$far_cloud.scroll_base_offset -= Vector2(1, 0) * 80 * delta_time
	$near_cloud.scroll_base_offset -= Vector2(1, 0) * 120 * delta_time

func _on_first_body_entered(body):
	if body is Player:
		GLOBAL.can_climb = true

func _on_first_body_exited(body):
	if body is Player:
		GLOBAL.can_climb = false


func _on_timer_enemy_timeout():
	if GLOBAL.enemy_death:
		var enemy_instance = enemy.instantiate()
		enemy_instance.global_position = $Node2D/Path2D/PathFollow2D.global_position
		add_child(enemy_instance)
		GLOBAL.enemy_death = false

func parse_vector2(position_string: String) -> Vector2:
	# Eliminar los paréntesis de la cadena
	position_string = position_string.strip_edges().strip_edges(false, true)
	var parts = position_string.split(", ")
	return Vector2(parts[0].to_float(), parts[1].to_float())
