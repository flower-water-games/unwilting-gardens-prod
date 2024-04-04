extends Node3D
class_name MainMenu3D

@onready var color_rect : ColorRect = %ColorRect
@export var button : Button
@export var main_menu_music : AudioStreamPlayer
@export var main_menu_stinger : AudioStreamPlayer
@export var camera : Camera3D
@export var version_label : Label
var level_path : String = ("res://FRESH-FLOWERS/Scenes/loading_screen.tscn")

func _ready() -> void:
	button.pressed.connect(exit_fade)
	fade_in(1)
	main_menu_music.play()

	# camera back and forth
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position:z", 4.7, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "position:z", 4.6, 2.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# tween.set_loops(5)

	var new_tween = get_tree().create_tween()
	new_tween.tween_property(camera, "rotation_degrees:x", -1.5, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	new_tween.tween_property(camera, "rotation_degrees:x", -.9, .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	new_tween.tween_property(camera, "rotation_degrees:x", 0, 2.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# new_tween.set_loops(5)
	# get version number from project settings
	version_label.text = "unwilting-" + ProjectSettings.get_setting("application/config/version")


func fade_in(duration):
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(color_rect, "color:a", 0, duration)
	
func fade_out(duration):
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(color_rect, "color:a", 1, duration)


func exit_fade():
	button.hide()
	main_menu_music.stop()
	main_menu_stinger.play()
	fade_out(5)
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file(level_path)


