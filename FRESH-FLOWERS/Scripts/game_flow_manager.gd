extends Node3D

class_name GameFlowManager

@export_category("World Nodes")
@export var world_node: Node3D
@export var stage1_area : Area3D
@export var stage2_area : Area3D
@export var music_manager : GardenMusicManager


#
# @export_category("UI Fade In")
@onready var fade_tween = get_tree().create_tween()
@onready var color_rect : ColorRect = %ColorRect

func _ready():
	world_node.hide()
	fade_in(5)
	




# FADE IN AND OUT

func fade_in(duration):
	fade_tween.tween_property(color_rect, "color:a", 0, duration)
	
func fade_out(duration):
	fade_tween.tween_property(color_rect, "color:a", 1, duration)