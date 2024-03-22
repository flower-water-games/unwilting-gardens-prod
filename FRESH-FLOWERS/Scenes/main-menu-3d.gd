extends Node3D
class_name MainMenu3D

@onready var color_rect : ColorRect = %ColorRect
@export var button : Button
@export var main_menu_music : AudioStreamPlayer


func fade_in(duration):
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(color_rect, "color:a", 0, duration)
	
func fade_out(duration):
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(color_rect, "color:a", 1, duration)


func exit_fade():
	button.hide()
	main_menu_music.stop()
	fade_out(2)

func _ready() -> void:
	button.pressed.connect(exit_fade)
	fade_in(1)
	main_menu_music.play()
