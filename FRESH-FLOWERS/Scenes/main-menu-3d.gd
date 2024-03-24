extends Node3D
class_name MainMenu3D

@onready var color_rect : ColorRect = %ColorRect
@export var button : Button
@export var main_menu_music : AudioStreamPlayer
@export var camera : Camera3D

func _ready() -> void:
	button.pressed.connect(exit_fade)
	fade_in(1)
	main_menu_music.play()

	# camera back and forth
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position:z", 4.7, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "position:z", 4.6, 2.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# tween.set_loops(-1)

	var new_tween = get_tree().create_tween()
	new_tween.tween_property(camera, "rotation_degrees:x", -1.5, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	new_tween.tween_property(camera, "rotation_degrees:x", -.9, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	new_tween.tween_property(camera, "rotation_degrees:x", 0, 2.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# new_tween.set_loops(-1)


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


