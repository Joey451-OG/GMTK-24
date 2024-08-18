extends Node2D

@export var scale_factor := 0.2
@export var thrown_speed := 2.0
@export var bullet_time_amount := 20
@export var time_scale := 0.2
@export var bullet_time_drain_rate := 0.2
@export var despawn_time := 5.0
@export var despawn_partical := CPUParticles2D

@onready var bt_amount = bullet_time_amount
@onready var bt_drain_rate = 1 - bullet_time_drain_rate

var scale_clamp := [0.6, 4.0]
var tracked_box : Node2D
var selected_box_time : float

func _process(delta: float) -> void:
	if tracked_box != null: 
		_scale_box(delta)
		_bullet_time(delta)
	
		if tracked_box.get_meta("isThrown"):
			_fire_projectile(delta)
		else:
			#selected_box_velocity = Vector2.ZERO
			pass

func _scale_box(detla: float):
	# turn the glow effect on to show which box is selected
	tracked_box.glowish.visible = true
	
	# Scale up or down based on scroll whell
	if Input.is_action_just_pressed("scrollUp"):
		tracked_box.scale *= scale_factor + 1 # lerp this eventually
		thrown_speed *= 1 - scale_factor
		$PlayerBody/GunScene._get_marker().position.x *= (scale_factor / 2) + 1
		
	elif Input.is_action_just_pressed("scrollDown"):
		tracked_box.scale *= 1 - scale_factor # lerp eventually
		thrown_speed *= 1 + scale_factor
		$PlayerBody/GunScene._get_marker().position.x *= 1 - (scale_factor / 2) 
	
	#clamp(s)
	tracked_box.scale = Vector2(clampf(tracked_box.scale.x, scale_clamp[0], scale_clamp[1]), clampf(tracked_box.scale.y, scale_clamp[0], scale_clamp[1]))
	thrown_speed = clampf(thrown_speed, scale_clamp[0], scale_clamp[1])
	$PlayerBody/GunScene._get_marker().position.x = clampf($PlayerBody/GunScene._get_marker().position.x, 90.0, 190.0)

func _bullet_time(delta: float):
	# Bullet Time
	if Input.is_action_pressed("rightClick"):
		#enter_bullet_time.emit() # Uncomment this when music is setup
		if bt_amount > 0.00000001:
			# slow down time
			Engine.time_scale = time_scale
			bt_amount *= bt_drain_rate
			tracked_box.set_meta("notInBT", false)
		else:
			# same as below elif without recharging the bullet time
			Engine.time_scale = 1
			
			# set metadata of box
			tracked_box.set_meta("isThrown", true)
			tracked_box.set_meta("notInBT", true)
			
			
	elif Input.is_action_just_released("rightClick"):
		# reset bulllet time and call _fire_projectile()
		
		#exit_bullet_time.emit() # Uncomment this when music is setup
		Engine.time_scale = 1
		bt_amount = bullet_time_amount

		# | set box metadata |
		# These tags are mostly unessisary with the current system
		# but I have a hunch they may come in handy
		tracked_box.set_meta("isThrown", true)
		tracked_box.set_meta("notInBT", true)
		

func _fire_projectile(delta: float):
	# play firing animation
	$PlayerBody/GunScene._fire_animation()
	
	# set metadata for projectile
	tracked_box.set_meta("isFired", true)
	
	# Start timer	
	selected_box_time += (2.4) * delta
	
	# right now we can get the angle at which the gun is pointing.
	# we need a way to add a magnitude and apply it as velocity. - Joey
	#selected_box_velocity = $PlayerBody/GunScene._get_firing_angle()
	
	if selected_box_time > despawn_time:
		_despawn_box_object(tracked_box)
		selected_box_time = 0.0
		$PlayerBody/GunScene.wasAnimationPlayed = false
		$PlayerBody/GunScene.isInPosition = false

func _despawn_box_object(target : Node2D):
	despawn_partical.global_position = target.global_position
	despawn_partical.emitting = true
	tracked_box = null
	target.queue_free()

# signal functions
func _recive_box(box):
	tracked_box = box
