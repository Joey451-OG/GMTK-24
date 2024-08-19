extends Node2D

@export var Gun_Scene : Node2D
@export var despawn_time := 5.0
@export var despawn_partical := CPUParticles2D
var selected_box_time := 0.0
var tracked_box : RigidBody2D
var isTimerRunning := false

func _recive_box(box: RigidBody2D, speed: float):
	isTimerRunning = true
	
	tracked_box = box
	tracked_box.set_meta("isThrown", false)
	tracked_box.set_meta("isFired", true)
	Gun_Scene.target_box = null
	
	tracked_box.linear_velocity = Gun_Scene._get_fire_vector() * speed
	
func _process(delta: float) -> void:
	if isTimerRunning and tracked_box != null:
		selected_box_time += (2.4) * delta

		if selected_box_time > despawn_time:
			_despawn_box_object()
			selected_box_time = 0.0
			isTimerRunning = false
			
func _despawn_box_object():
	despawn_partical.global_position = tracked_box.global_position
	despawn_partical.emitting = true
	tracked_box.queue_free()
