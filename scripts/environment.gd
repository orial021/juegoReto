extends Node2D

func ready():
	$Area2D/CollisionShape2D.set_collision_layer_bit(0, false)
	$Area2D/CollisionShape2D.set_collision_mask_bit(0, false)
	
func _process(delta) -> void:
	parallax_bg(delta)
	
	
func parallax_bg(delta_time) -> void:
	$Node/sky.scroll_base_offset -= Vector2(1, 0) * 4 * delta_time
	$Node/far_cloud.scroll_base_offset -= Vector2(1, 0) * 40 * delta_time
	$Node/near_cloud.scroll_base_offset -= Vector2(1, 0) * 24 * delta_time
	$Node/far_mountain.scroll_base_offset -= Vector2(1, 0) * 0 * delta_time
	$Node/near_mountain.scroll_base_offset -= Vector2(1, 0) * 0 * delta_time
	$Node/trees.scroll_base_offset -= Vector2(1, 0) * 0 * delta_time
	


func _on_area_2d_area_entered(_Player):
	GLOBAL.can_climb = true
	

func _on_area_2d_area_exited(_Player):
	GLOBAL.can_climb = false
