extends Node3D

class_name Wieldable

@export_group("General Wieldable Settings")
## Item resource that this wieldable refers to.
# @export var item_reference : WieldableItemPD
## Visible parts of the wieldable. Used to hide/show on equip/unequip.
@export var wieldable_mesh : Node3D

@export_group("AudioVisual")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

# var player_interaction_component: PlayerInteractionComponent

func _ready():
	# wieldable_mesh.hide()
	pass

# func action_primary(_passed_item_reference:InventoryItemPD, is_released: bool):
# 	pass

func action_primary():
	pass

func action_primary_released():
	pass

func action_secondary():
	pass

# Function called when wieldable reload is attempted
func reload():
	pass


