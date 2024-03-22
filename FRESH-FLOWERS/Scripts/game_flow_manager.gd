extends Node3D

class_name GameFlowManager

# REFERENCES TO NODES IN WORLD
@export_category("World Nodes")
@export var player : Player
@onready var watering_can : WateringCan = player.wieldable
@export var world_node: Node3D
@export var tutorial_island: Node3D
@export var tutorial_end_hitbox : Area3D
@export var stage1_area : Area3D
@export var stage2_area : Area3D
@export var music_manager : GardenMusicManager


# UI FADE IN
# @export_category("UI Fade In")
@onready var fade_tween = get_tree().create_tween()
@onready var color_rect : ColorRect = %ColorRect

# CREDITS
@onready var credits : Label = %CREDITS

var stage3_in_progress = false
var game_over = false
# ready
func _ready():
	world_node.hide()

	tutorial_end_hitbox.connect("body_entered", _on_tutorial_end)

	# connect the area entered signal
	stage1_area.connect("body_entered", _stage_1_entered)
	stage1_area.connect("body_exited", _on_area_exit)

	stage2_area.connect("body_entered", _stage_2_entered)
	stage2_area.connect("body_exited", _on_area_exit)	


	fade_in(5)
	
func _on_tutorial_end(body):
	if body.is_in_group("Player"):
		world_node.show()
		tutorial_island.queue_free()
		watering_can.water_capacity = 20

func _stage_1_entered(body):
	if body.is_in_group("Player"):
		music_manager.play_stage_1()


func _stage_2_entered(body):
	if body.is_in_group("Player"):
		music_manager.play_stage_2()

func _on_area_exit(body : Node3D):
	# if stage 3 is not playing, stop the music
	if body.is_in_group("Player"): 
		MusicManager.stop(1)

func stage3():
	stage1_area.queue_free()
	stage2_area.queue_free()
	music_manager.play_stage_3()


# FADE IN AND OUT
func fade_in(duration):
	fade_tween.tween_property(color_rect, "color:a", 0, duration)
	
func fade_out(duration):
	fade_tween.tween_property(color_rect, "color:a", 1, duration)

func _process(delta):

	if stage3_in_progress and not game_over:
		if music_manager.is_stage_3_complete():
			print("GAME OVER!")
			game_over = true
			MusicManager.stop(5)
			MusicManager.play("Music", "finale", 5)
			await get_tree().create_timer(15).timeout
			credits.show()
	elif music_manager.is_stage_1_complete() and music_manager.is_stage_2_complete():
		print("STAGE 3 IN PROGRESS")
		stage3_in_progress = true
		stage3()
