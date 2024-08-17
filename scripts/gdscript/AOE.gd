extends Node2D

# signals
# these control the bullet time music - Aveca
signal enter_bullet_time
signal exit_bullet_time


@export var pivot_num := 3
@export var scale_factor := 0.2
@export var thrown_speed := 2.0
@export var time_scale := 0.2
@export var bullet_time_amount := 20
@export var bullet_time_drain_rate := 0.2

@export var despawn_time := 5; 
@export var despawn_partical := CPUParticles2D

@onready var box_list = {}

@onready var pivot_3 = [$orbital_zone/pivot_3/Node2D, $orbital_zone/pivot_3/Node2D2, $orbital_zone/pivot_3/Node2D3]
@onready var pivot_4 = [$orbital_zone/pivot_4/Node2D, $orbital_zone/pivot_4/Node2D2, $orbital_zone/pivot_4/Node2D3, $orbital_zone/pivot_4/Node2D4]
@onready var pivot_5 = [$orbital_zone/pivot_5/Node2D, $orbital_zone/pivot_5/Node2D2, $orbital_zone/pivot_5/Node2D3, $orbital_zone/pivot_5/Node2D4, $orbital_zone/pivot_5/Node2D5]
@onready var pivot_6 = [$orbital_zone/pivot_6/Node2D, $orbital_zone/pivot_6/Node2D2, $orbital_zone/pivot_6/Node2D3, $orbital_zone/pivot_6/Node2D4, $orbital_zone/pivot_6/Node2D5, $orbital_zone/pivot_6/Node2D6]
@onready var clouds := [pivot_3, pivot_4, pivot_5, pivot_6]
@onready var world_7 := [$orbital_zone/pivot_3, $orbital_zone/pivot_4, $orbital_zone/pivot_5, $orbital_zone/pivot_6]
@onready var bt_drain_rate = 1 - bullet_time_drain_rate
@onready var bt_amount = bullet_time_amount

var tracked_box : Node2D
var number_of_tracked_boxes := 0
var scale_clamp := [0.6, 10.0]
var velocity_vector : Vector2

var selected_box_velocity : Vector2
var selected_box_time : float


func _process(delta) -> void:
	_rotate_point_cloud(delta, 1.4)
	var begin_i = 0
	for box in box_list.keys():
		_calculate_box_logic(box_list[box], clouds[pivot_num - 3][begin_i].global_position, delta)
		begin_i += 1
	
	if tracked_box != null:
		if number_of_tracked_boxes <= 1:
			_tracked_box(delta)
		if tracked_box.get_meta("isThrown"):
			selected_box_time += (2.4) * delta
			selected_box_velocity = velocity_vector
			if selected_box_time > despawn_time:
				_despawn_box_object(tracked_box)
				selected_box_time = 0.0
		else: 
			selected_box_velocity = Vector2.ZERO
			
		if tracked_box != null:
			tracked_box.position += (thrown_speed * -selected_box_velocity) * delta
			
	

func _rotate_point_cloud(delta : float, mag : float) -> void:
	world_7[pivot_num - 3].rotation += mag * delta

func _calculate_box_logic(box, target_point : Vector2, delta) -> void:
	box.position = lerp(box.position, target_point, 4.4 * delta)

func _tracked_box(delta: float):
	# turn the glow effect on to show which box is selected
	tracked_box.glowish.visible = true
	
	# freeze the box's position upon entering bullet time
	if tracked_box.get_meta("notInBT") and !tracked_box.get_meta("isThrown"): tracked_box.position = lerp(tracked_box.position, get_global_mouse_position(), 14.4 * delta)
	
	# Scale up or down based on scroll whell
	if Input.is_action_just_pressed("scrollUp"):
		tracked_box.scale *= scale_factor + 1 # lerp this eventually
		thrown_speed *= 1 - scale_factor
	elif Input.is_action_just_pressed("scrollDown"):
		tracked_box.scale *= 1 - scale_factor # lerp eventually
		thrown_speed *= 1 + scale_factor
	
	# Bullet Time
	elif Input.is_action_pressed("rightClick"):
		enter_bullet_time.emit()
		if bt_amount > 0.00000001:
			# begin charging
			velocity_vector = get_local_mouse_position() - tracked_box.global_position
			#print(velocity_vector)
			
			#slow down time
			Engine.time_scale = time_scale
			bt_amount *= bt_drain_rate
			tracked_box.set_meta("notInBT", false)
		else:
			# same as below elif without recharging the bullet time
			Engine.time_scale = 1
			# add code once done below
			tracked_box.set_meta("isThrown", true)
			tracked_box.set_meta("notInBT", false)
			
	elif Input.is_action_just_released("rightClick"):
		# reset bulllet time and fling das Block!
		exit_bullet_time.emit()
		Engine.time_scale = 1
		bt_amount = bullet_time_amount
		
		# add a physics object to the box and apply velocity_vector
		tracked_box.set_meta("isThrown", true)
		tracked_box.set_meta("notInBT", false)
	
	#clamp(s)
	tracked_box.scale = Vector2(clampf(tracked_box.scale.x, scale_clamp[0], scale_clamp[1]), clampf(tracked_box.scale.y, scale_clamp[0], scale_clamp[1]))
	thrown_speed = clampf(thrown_speed, scale_clamp[0], scale_clamp[1])
	print(thrown_speed)
	
# Signaled Functions
func _update_box_list(box, id) -> void:
	if box.get_meta("id") not in box_list.keys() and box_list.size() < pivot_num:
		box_list[id] = box
		tracked_box = null
		number_of_tracked_boxes = 0
	elif box.get_meta("id") in box_list.keys() and number_of_tracked_boxes < 1:
		# remove box from list and create a reference to the box
		tracked_box = box_list[id]
		box_list.erase(id)
		number_of_tracked_boxes += 1

func _despawn_box_object(target : Node2D):
	despawn_partical.global_position = target.global_position
	despawn_partical.emitting = true
	tracked_box = null
	target.queue_free()
	number_of_tracked_boxes = 0
