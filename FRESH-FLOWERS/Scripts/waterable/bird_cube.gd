extends Waterable
class_name BirdCube

var path_follow:PathFollow3D
@onready var flying_animation_player:AnimationPlayer = %FlyingAnimationPlayer

func _ready():
	super()
	path_follow = get_parent()

var speed = 0.1

var move_to_next = false
var movement_completed = false

func _physics_process(delta: float) -> void:

	if move_to_next:
		path_follow.progress_ratio += (speed * delta) 
		self.gravity_scale = 0.0
		
		if path_follow.progress_ratio > 0.99:
			move_to_next = false
			movement_completed = true

func _on_threshold_reached():
	super()
	# flying_animation_player.play("flying")
	if not movement_completed:
		move_to_next = true
