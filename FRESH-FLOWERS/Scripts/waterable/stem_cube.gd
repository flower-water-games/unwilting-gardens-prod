extends Waterable


class_name StemCube

@export var stem_name : String
var garden_music_manager : GardenMusicManager = null

func _ready() -> void:
	super()
	garden_music_manager = get_node("/root/GardenMusicManager")


func _on_threshold_reached():
	super()
	garden_music_manager.enable_stem(stem_name)


