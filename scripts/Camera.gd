extends Camera2D

@export_category("Config")

@export_group("Required Refrences")
@export var player : CharacterBody2D


func _proccess(_delta):
	global_position = player.global_position
