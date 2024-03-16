extends Node3D

class_name GardenMusicManager

# two area 3ds, one for stage 1 music, stage 2 music, 
@export var stage1_area : Area3D
@export var stage2_area : Area3D

# when entered / exits, triggers stage 1 vs stage 2 respectively
func _ready():

	# connect the area entered signal
	stage1_area.connect("body_entered", _stage_1_entered)
	stage1_area.connect("body_exited", _on_area_exit)

	stage2_area.connect("body_entered", _stage_2_entered)
	stage2_area.connect("body_exited", _on_area_exit)	
	
	level_1.hide()
	level_2.hide()

	# connect sound manager loaded
	SoundManager.connect("loaded", on_sound_manager_load)

func on_sound_manager_load():
	SoundManager.play("player", "wind")

func _on_area_exit(node):
	# if stage 3 is not playing, stop the music
	if node.is_in_group("Player") and not is_stage_3:
		MusicManager.stop(.1)
		print("music stopped")

func _stage_1_entered(node):

	# play stage 1 music
	# if the body is in the group "player"

	if node.is_in_group("Player"):
		# first time enter the level1, destroy the tutorial island
		level_1.show()
		level_2.show()
		# level_2.hide()
		if (is_stage_3):
			return
		if (!is_stage_2):
			tutorial_island.queue_free()
			# PLAYS ONCE LEVEL ONE ENTERS
			player.wieldable.water_capacity = 16.0
		
		MusicManager.play("Music", "Stage1", .1)
		# enable all stems for stage 1 that are playing already
		for stem in stage1_stems:
			MusicManager.enable_stem(stem)
		print("stage 1 music playing")


func _stage_2_entered(node):
	# play stage 2 music if player entered
	if node.is_in_group("Player"):	
		# level_1.hide()
		if (is_stage_3):
			return
		MusicManager.play("Music", "Stage2", .1)
		for stem in stage2_stems:
			MusicManager.enable_stem(stem)
		print("stage 2 music playing")
	

# two dictionaries per stage, to remember which stems are playing
var stage1_total_additional_stems = 3 
var stage2_total_additional_stems = 4
var stage3_total_additional_stems = 3
# stage 3 find "lead", "lead1", and "chords"

var stage1_all_stems_found = false;
var stage2_all_stems_found = false;
var stage3_all_stems_found = false;

var stage1_stems = {}
var stage2_stems = {}
var stage3_stems = {}

func _is_stage_playing(num: int) -> bool:
	return MusicManager.is_playing("Music", "Stage" + str(num))

func enable_stem(stem_name: String):
	if _is_stage_playing(1):
		# first check if the stem is already playing
		if stem_name in stage1_stems:
			return
		# if not, add it to the dictionary
		stage1_stems[stem_name] = true
		if len(stage1_stems) == stage1_total_additional_stems:
			# if all stems are playing, all_playing is true
			stage1_all_stems_found = true

	elif _is_stage_playing(2):
		if stem_name in stage2_stems:
			return
		stage2_stems[stem_name] = true
		if len(stage2_stems) == stage2_total_additional_stems:
			# if all stems are playing, all_playing is true
			stage2_all_stems_found = true
	elif _is_stage_playing(3):
		if stem_name in stage3_stems:
			return
		stage3_stems[stem_name] = true
		if len(stage3_stems) == stage3_total_additional_stems:
			# if all stems are playing, all_playing is true
			stage3_all_stems_found = true
		# if stage 3 is playing, do nothing
		return
	else:
		# if no stage is playing, do nothing
		return

	MusicManager.enable_stem(stem_name)

var is_stage_3 = false
@export var stage_3 : Node3D
func stage3():
	print("stage 3")
	# wait 30 seconds
	if (is_stage_3):
		return
	is_stage_3 = true
	stage_3.show()


	## THREE PHASES IN STAGE 3

	# 1. 10 seconds to prepare to dance (time_to_party) 
	# 2. 10 seconds for lights to come down, and music track begins
	# 3. once player finds all the stem cubes, play final track

	# phase 1: wait 10 seconds and fade out the music
	MusicManager.stop(10)
	await get_tree().create_timer(time_to_party).timeout 
	print("stage 3 party time. 10s to prepare to dance.")

	# phase 2: tween down lights, and start music
	var tween = get_tree().create_tween()
	tween.tween_property(regular_light, "light_color", color_to_tween, time_to_music_start)
	tween.tween_property(regular_light, "light_energy", 4.0, time_to_music_start)
	MusicManager.play("Music", "Stage3", time_to_music_start)

#subcategory for gameflow locks
@export_subgroup("Gameflow references")
@export var stage1_lock : Node3D
@export var tutorial_island: Node3D
@export var player : Player
@export var level_1 : Node3D
@export var level_2 : Node3D
@export var dome : Node3D

@onready var dome_animation_player : AnimationPlayer = dome.get_node("%DomeAnimationPlayer")

@export_subgroup("Dance Party")
@export var time_to_music_start : float = 10.0
@export var time_to_party : float = 10.0
@export var color_to_tween : Color
@export var regular_light : DirectionalLight3D

var is_stage_2 = false
var game_over = false

func stage2():
	# unlock stage 3
	print("stage 1 completed, unlock stage 2")
	stage1_lock.queue_free()
	dome_animation_player.play("Dissapear")
	# dome has a child animation player and needs to play 2 animations named: 
		# "Dissapear" and "Disappear_001"
	pass

func _process(delta):
	# if all stems are playing, stop the music
	if game_over:
		return
	if stage1_all_stems_found and not is_stage_2:
		is_stage_2 = true
		stage2()

	if stage1_all_stems_found and stage2_all_stems_found:
		stage1_all_stems_found = false
		stage3()

	if stage3_all_stems_found:
		print("GAME OVER!")
		game_over = true
		MusicManager.stop(5)
		MusicManager.play("Music", "finale", 5)
	# # if I press number 1 on keyboard, activate stage2, for testing
	# if Input.is_key_pressed(KEY_2):
	# 	stage2()
	if Input.is_key_pressed(KEY_3):
		stage3()
