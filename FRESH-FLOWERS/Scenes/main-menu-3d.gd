extends Node3D
class_name MainMenu3D

@onready var color_rect : ColorRect = %ColorRect
@onready var fade_tween = get_tree().create_tween()


func fade_in(duration):
	fade_tween.tween_property(color_rect, "color:a", 0, duration)
    
func fade_out(duration):
	fade_tween.tween_property(color_rect, "color:a", 1, duration)



func _ready() -> void:
	fade_in(1)