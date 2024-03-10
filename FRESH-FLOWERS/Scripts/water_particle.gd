extends CharacterBody3D

@export var speed = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func set_start_velocity():
	velocity = (global_transform.basis * Vector3.FORWARD).normalized() * speed


var time = 0.0
# after 3 seconds, the bullet will be destroyed
func _physics_process(delta: float) -> void:
	time+=delta
	# check if its been 3 seconds since been instantiated
	if time > 3:
		queue_free()
		return
	velocity.y -= gravity * delta

	# look_at(position + velocity)

	move_and_slide()

	if get_slide_collision_count() > 0:
		for i in range(0, get_slide_collision_count()):
			var collision = get_slide_collision(i).get_collider()
			# if collision.is_in_group("Cube"):
			# 	collision.queue_free()
			# 	print("collided with cube")
			if collision.has_method("water"):
				collision.water()
				queue_free()
			else:
				# print("collided with something else")
				queue_free()
