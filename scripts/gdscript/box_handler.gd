extends Node2D

@export var Gun_Scene : Node2D
@export var despawn_partical := CPUParticles2D
@export var audio_manager : AudioStreamPlayer2D
var tracked_box : RigidBody2D

func _recive_box(box: RigidBody2D, speed: float):
	tracked_box = box
	tracked_box.set_meta("isThrown", false)
	Gun_Scene.target_box = null
	
	tracked_box.linear_velocity = Gun_Scene._get_fire_vector() * speed

func _despawn_box_object(box: Node2D):
	despawn_partical.global_position = box.global_position
	despawn_partical.emitting = true
	audio_manager._play_throw()
	box.queue_free()
