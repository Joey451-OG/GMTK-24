extends Node2D

@export var scale_factor := 0.2
@export var thrown_speed := 2.0
@export var bullet_time_amount := 20
@export var time_scale := 0.2
@export var bullet_time_drain_rate := 0.2

@onready var bt_amount = bullet_time_amount
@onready var bt_drain_rate = 1 - bullet_time_drain_rate

var tracked_box : Node2D

func _process(delta: float) -> void:
	if tracked_box != null : _scale_box(delta)


func _scale_box(detla: float):
	# turn the glow effect on to show which box is selected
	tracked_box.glowish.visible = true
	
	# Scale up or down based on scroll whell
	if Input.is_action_just_pressed("scrollUp"):
		tracked_box.scale *= scale_factor + 1 # lerp this eventually
		thrown_speed *= 1 - scale_factor
	elif Input.is_action_just_pressed("scrollDown"):
		tracked_box.scale *= 1 - scale_factor # lerp eventually
		thrown_speed *= 1 + scale_factor
	
	# Bullet Time
	elif Input.is_action_pressed("rightClick"):
		#enter_bullet_time.emit()
		if bt_amount > 0.00000001:
			
			# slow down time
			Engine.time_scale = time_scale
			bt_amount *= bt_drain_rate
			tracked_box.set_meta("notInBT", false)
		else:
			# same as below elif without recharging the bullet time
			Engine.time_scale = 1
			# add code once done below
			tracked_box.set_meta("isThrown", true)
			tracked_box.set_meta("notInBT", false)
			if !tracked_box.get_meta("isFired"):
				tracked_box.set_meta("isFired", true)
			
	elif Input.is_action_just_released("rightClick"):
		# reset bulllet time and fling das Block!
		#exit_bullet_time.emit()
		Engine.time_scale = 1
		bt_amount = bullet_time_amount
		
		# add a physics object to the box and apply velocity_vector
		tracked_box.set_meta("isThrown", true)
		tracked_box.set_meta("notInBT", false)
		if !tracked_box.get_meta("isFired"):
				tracked_box.set_meta("isFired", true)


func _recive_box(box):
	tracked_box = box
