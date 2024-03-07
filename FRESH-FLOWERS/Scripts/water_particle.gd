extends CharacterBody3D

@export var speed = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func set_start_velocity():
	velocity = (global_transform.basis * Vector3.FORWARD).normalized() * speed


func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta

	look_at(position + velocity)

	move_and_slide()

	if get_slide_collision_count() > 0:
		for i in range(0, get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if collision.has_method("water"):
				collision.collider.queue_free()
				print("watering")
