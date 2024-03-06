extends Node3D

class_name Waterable


var moisture_level = 0.0
@export var max_moisture_level = 9.0
@export var threshold = 3.0
@onready var initial_scale = scale

@onready var flower_cube_mesh:MeshInstance3D = %FlowerCubeMesh

@export var my_happy_material:StandardMaterial3D = null
@export var my_sad_material:StandardMaterial3D = null

var watering_sfx_instance:PooledAudioStreamPlayer

func _ready():
	# Implement logic to initialize the visual representation of the moisture level here
	flower_cube_mesh.material_override = my_sad_material

	SoundManager.connect("loaded", on_sound_manager_load)

func on_sound_manager_load():
	watering_sfx_instance = SoundManager.instance("player", "watering")


var threshold_reached = false

func water(amount):
	moisture_level += amount
	scale_up_tween()
	print('watering')
	if not watering_sfx_instance.playing:
		watering_sfx_instance.trigger()

	if moisture_level >= threshold and not threshold_reached:
		_on_threshold_reached()
	
	if moisture_level >= max_moisture_level:
		moisture_level = max_moisture_level
		watering_sfx_instance.release()
		SoundManager.play("player", "watered")


	# Implement additional logic here (e.g., visual feedback, triggering growth

var scale_up_factor = .2
func scale_up_tween():
	var normalized_moisture_level = moisture_level / max_moisture_level
	var new_scale = Vector3(initial_scale.x, initial_scale.y, initial_scale.z) + Vector3(scale_up_factor, scale_up_factor, scale_up_factor) * normalized_moisture_level
	scale = new_scale
	# TODO tween the scale 
	# var tween = create_tween()
	# tween.tween_property(self, "scale", new_scale, .5)
	# set an ease that bounces on complete
	# tween.set_ease( Tween.EASE_OUT)

func _on_threshold_reached():
	# Implement logic to trigger growth here
	threshold_reached = true
	flower_cube_mesh.material_override = my_happy_material
	SoundManager.play("player", "complete")
	# print('warning: not implemented -> threshold reached')
