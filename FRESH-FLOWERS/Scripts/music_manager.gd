extends Node3D

class_name GardenMusicManager

# two area 3ds, one for stage 1 music, stage 2 music, 
@export var stage1_area : Area3D
@export var stage2_area : Area3D


# when entered / exits, triggers stage 1 vs stage 2 respectively
func _ready():
	# connect sound manager loaded
	SoundManager.connect("loaded", on_sound_manager_load)
	


func on_sound_manager_load():
	SoundManager.play("player", "wind")
	MusicManager.play("Music", "water-flow")


func play_stage_1():
	MusicManager.play("Music", "Stage1", .1)
	# enable all stems for stage 1 that are playing already
	for stem in stage1_stems:
		MusicManager.enable_stem(stem)

func play_stage_2():
	MusicManager.play("Music", "Stage2", .1)
	for stem in stage2_stems:
		MusicManager.enable_stem(stem)

@export_subgroup("Dance Party")
@export var time_to_music_start : float = 10.0
@export var time_to_party : float = 10.0
@export var color_to_tween : Color
@export var regular_light : DirectionalLight3D

func play_stage_3():
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
	

# two dictionaries per stage, to remember which stems are playing

@export_category("Number Of Stems Per Stage")
@export var stage1_total_additional_stems = 3 
@export var stage2_total_additional_stems = 4
@export var stage3_total_additional_stems = 3

var stage1_all_stems_found = false;
var stage2_all_stems_found = false;
var stage3_all_stems_found = false;

var stage1_stems = {}
var stage2_stems = {}
var stage3_stems = {}

func _is_stage_playing(num: int) -> bool:
	return MusicManager.is_playing("Music", "Stage" + str(num))

func is_stage_1_complete() -> bool:
	if len(stage1_stems) == stage1_total_additional_stems:
			# if all stems are playing, all_playing is true
			stage1_all_stems_found = true
	return stage1_all_stems_found

func is_stage_2_complete() -> bool:
	if len(stage2_stems) == stage2_total_additional_stems:
			# if all stems are playing, all_playing is true
			stage2_all_stems_found = true
	return stage2_all_stems_found

func is_stage_3_complete() -> bool:
	if len(stage3_stems) == stage3_total_additional_stems:
			# if all stems are playing, all_playing is true
			stage3_all_stems_found = true
	return stage3_all_stems_found

func enable_stem(stem_name: String):
	if _is_stage_playing(1):
		# first check if the stem is already playing
		if stem_name in stage1_stems:
			return
		# if not, add it to the dictionary
		stage1_stems[stem_name] = true
		is_stage_1_complete()
	elif _is_stage_playing(2):
		if stem_name in stage2_stems:
			return
		stage2_stems[stem_name] = true
		is_stage_2_complete()
	elif _is_stage_playing(3):
		if stem_name in stage3_stems:
			return
		stage3_stems[stem_name] = true
		is_stage_3_complete()
	else:
		# if no stage is playing, do nothing
		return

	MusicManager.enable_stem(stem_name)