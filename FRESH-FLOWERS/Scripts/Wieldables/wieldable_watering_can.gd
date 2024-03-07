extends Wieldable 
class_name WateringCan

@export var water_capacity: float = 16.0
@export var drainage_rate: float = 1.0
var current_water_level: float = water_capacity

@onready var water_stream: GPUParticles3D = $WaterStream
@onready var interaction_raycast: ShapeCast3D = $ShapeCast3D
@onready var original_rotation: Vector3 = rotation_degrees
@onready var target_rotation_z: float = rotation_degrees.z + 10

@export var watering_indicator_sphere : Node3D

var is_watering: bool = false
var watering_timer: Timer = Timer.new()

var watering_target: Waterable

func _ready():
	super._ready()
	add_child(watering_timer)
	setup_watering_timer()

func _process(delta: float) -> void:
	if is_watering:
		check_for_waterable_surface()
	update_water_level_based_on_usage()

func setup_watering_timer() -> void:
	watering_timer.wait_time = 1.0
	watering_timer.one_shot = false
	watering_timer.timeout.connect(_on_watering_timer_timeout)

func check_for_waterable_surface() -> void:
	if interaction_raycast.is_colliding():
		var target = interaction_raycast.get_collider(0)
		if target and target is Waterable:
			process_waterable_target(target)
		else:
			reset_watering_target()

func check_for_refill() -> void:
	if interaction_raycast.is_colliding():
		var target = interaction_raycast.get_collider(0)
		if target and target.has_method("refill"):
			refill_water()

func refill_water() -> void:
	current_water_level = water_capacity
	stop_watering()
	print("Watering Can: Refilled.")

func process_waterable_target(target: Waterable) -> void:
	if not is_watering:
		return

	if target != watering_target:
		reset_watering_target()
		watering_target = target

func reset_watering_target() -> void:
	if watering_target:
		watering_target.watering_sfx_instance.stop()
	watering_target = null

func start_watering() -> void:
	if not is_watering and current_water_level > 0:
		is_watering = true
		# water_stream.emitting = true
		tween_to_target_rotation(target_rotation_z)
		watering_timer.start()
		print("Watering Can: Started watering")


@export var water_particle: PackedScene
@export var node_to_spawn_under: Node3D

func spawn_particles(num : int) -> void:
	for i in range(num):
		# await get tree timer timeout 1 second
		await get_tree().create_timer(1 / num).timeout
		_create_water_particle()

func _create_water_particle():
	var w = water_particle.instantiate() as CharacterBody3D
	get_tree().get_root().add_child(w)
	w.global_position = node_to_spawn_under.global_position
	w.global_rotation = global_rotation
	# add 90 degrees to y rotation
	# w.rotation_degrees += Vector3(0, 90, 0)
	w.set_start_velocity()


func stop_watering() -> void:
	if is_watering:
		is_watering = false
		reset_watering_target()
		water_stream.emitting = false
		watering_timer.stop()
		tween_to_original_rotation()
		print("Watering Can: Stopped watering")

func tween_to_target_rotation(rotation: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees:z", rotation, 0.5)

func tween_to_original_rotation() -> void:
	tween_to_target_rotation(original_rotation.z)

func _on_watering_timer_timeout() -> void:

	use_water()

func use_water() -> void:
	if current_water_level > 0:
		current_water_level -= drainage_rate
		spawn_particles(50)
		if current_water_level <= 0:
			current_water_level = 0
			stop_watering()

		if watering_target:
			watering_target.water(drainage_rate)

		print("Watering Can: Used water. Current water level: ", current_water_level)
	else:
		stop_watering()
		print("Watering Can: Can is empty.")

var position_when_water_empty = -0.32
var position_when_water_full = 0.15

func update_water_level_based_on_usage() -> void:
	var water_level = lerp(position_when_water_empty, position_when_water_full, current_water_level / water_capacity)

	var tween = create_tween()
	tween.tween_property(watering_indicator_sphere, "position:y", water_level, 1.0)

	if is_watering and current_water_level <= 0:
		stop_watering()
	elif not is_watering and current_water_level < water_capacity:
		check_for_refill()
