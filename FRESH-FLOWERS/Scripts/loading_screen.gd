extends Control

@export var scene_path : String = "res://path_to_your_scene.tscn"

func _ready() -> void:
	# Start a request to load the resource.
	ResourceLoader.load_threaded_request(scene_path)
	# Connect a button's pressed signal to a function.

func _process(delta: float) -> void:
	# Check the status of the load.
	var status = ResourceLoader.load_threaded_get_status(scene_path)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		# The resource has finished loading.
		var scene = ResourceLoader.load_threaded_get(scene_path)
		get_tree().change_scene_to_packed(scene)
