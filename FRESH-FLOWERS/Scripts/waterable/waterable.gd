extends Node3D

class_name Waterable

var moisture_level = 0.0
@export var max_moisture_level = 9.0
@export var threshold = 3.0
@onready var initial_scale = scale

@onready var flower_cube_mesh:MeshInstance3D = %FlowerCubeMesh
@onready var animation_player:AnimationPlayer = %AnimationPlayer
@export var animation_name = "growing"

@export var my_happy_material:StandardMaterial3D = null
@export var my_sad_material:StandardMaterial3D = null

var watering_sfx_instance:PooledAudioStreamPlayer

@onready var watering_timer = Timer.new()

func setup_watering_timer() -> void:
	add_child(watering_timer)
	watering_timer.wait_time = 1.0
	watering_timer.one_shot = true
	watering_timer.timeout.connect(_on_watering_timer_timeout)

func _on_watering_timer_timeout():
	is_being_watered = false

func _ready():
	flower_cube_mesh.material_override = my_sad_material
	SoundManager.connect("loaded", on_sound_manager_load)
	setup_watering_timer()

func on_sound_manager_load():
	watering_sfx_instance = SoundManager.instance("player", "watering")

var threshold_reached = false

var is_being_watered = false

func water():
	if not is_being_watered:
		watering_timer.start()
		animation_player.play(animation_name)
		is_being_watered = true
		if not moisture_level > max_moisture_level:
			on_water()
		print("Watering")

func on_water():
	moisture_level += 1
	if not watering_sfx_instance.is_playing():
		watering_sfx_instance.trigger()

	if moisture_level >= threshold and not threshold_reached:
		watering_sfx_instance.release()
		_on_threshold_reached()
	
	if moisture_level >= max_moisture_level:
		moisture_level = max_moisture_level
		watering_sfx_instance.release()
		watering_timer.queue_free()
		SoundManager.play("player", "watered")

var scale_up_factor = .2

func scale_up_tween():
	var normalized_moisture_level = moisture_level / max_moisture_level
	var new_scale = Vector3(initial_scale.x, initial_scale.y, initial_scale.z) + Vector3(scale_up_factor, scale_up_factor, scale_up_factor) * normalized_moisture_level
	scale = new_scale

func _on_threshold_reached():
	threshold_reached = true
	flower_cube_mesh.material_override = my_happy_material
	SoundManager.play("player", "complete")
