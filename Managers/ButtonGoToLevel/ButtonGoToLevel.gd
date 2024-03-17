extends Node

@export var button : Button
@export var level_path : String = ("res://UserInterface/MainMenu/MainMenu.tscn")

func _ready():
	button.pressed.connect(_go_to_level)

func _go_to_level():

	# get root node of scene, which has a script which has a function fade_out we want to call
	var mm3d: MainMenu3D = get_tree().get_root().get_script()
	mm3d.fade_out(2)

	await get_tree().create_timer(2).timeout 
	print("go to: " + level_path)
	get_tree().change_scene_to_file(level_path)

	
