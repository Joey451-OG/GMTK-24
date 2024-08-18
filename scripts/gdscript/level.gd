extends Node2D

@export var scale_factor := 0.2
@export var thrown_speed := 2.0
@export var bullet_time_amount := 20
@export var time_scale := 0.2
@export var bullet_time_drain_rate := 0.2
@export var despawn_time := 5.0
@export var despawn_partical := CPUParticles2D
@export var box_handler : Node2D

@onready var bt_amount = bullet_time_amount
@onready var bt_drain_rate = 1 - bullet_time_drain_rate



var scale_clamp := [0.6, 4.0]
var tracked_box : Node2D
var selected_box_time : float
var list_of_working_boxes := []

func _process(delta: float) -> void:
	if tracked_box != null:  
		_scale_box(delta)
		_charge_projectile(delta)
	

func _scale_box(detla: float):
	# turn the glow effect on to show which box is selected
	tracked_box.glowish.visible = true
	
	var box_nodes = tracked_box.get_children(false)
	
	
	# Scale up or down based on scroll whell
	if Input.is_action_just_pressed("scrollUp"):
		for child in box_nodes:
			child.scale *= 1 + scale_factor
		thrown_speed *= 1 - scale_factor
		$PlayerBody/GunScene._get_marker().position.x *= (scale_factor / 2) + 1
		tracked_box.set_meta("maker_pos", $PlayerBody/GunScene._get_marker().position.x)
		
	elif Input.is_action_just_pressed("scrollDown"):
		for child in box_nodes:
			child.scale *= scale_factor - 1
		thrown_speed *= 1 + scale_factor
		$PlayerBody/GunScene._get_marker().position.x *= 1 - (scale_factor / 2)
	
	
	#clamp(s)
	
	#tracked_box.scale = Vector2(clampf(tracked_box.scale.x, scale_clamp[0], scale_clamp[1]), clampf(tracked_box.scale.y, scale_clamp[0], scale_clamp[1]))
	box_nodes[0].scale = Vector2(clampf(box_nodes[0].scale.x, 0.2, 1), clampf(box_nodes[0].scale.y, 0.2, 1)) #Physics Hitbox
	box_nodes[1].scale = Vector2(clampf(box_nodes[1].scale.x, scale_clamp[0], scale_clamp[1]), clampf(box_nodes[1].scale.y, scale_clamp[0], scale_clamp[1])) #Physics Hitbox
	
	
	thrown_speed = clampf(thrown_speed, 200, 1200)
	$PlayerBody/GunScene._get_marker().position.x = clampf($PlayerBody/GunScene._get_marker().position.x, 90.0, 190.0)

func _charge_projectile(delta: float):
	if Input.is_action_pressed("rightClick"):
		tracked_box.set_meta("isThrown", true)
		tracked_box.set_meta("isFired", true)
		
		box_handler._recive_box(tracked_box, thrown_speed)
		tracked_box = null

# signal functions
func _recive_box(box):
	tracked_box = box
