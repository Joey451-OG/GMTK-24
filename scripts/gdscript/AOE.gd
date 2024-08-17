extends Node2D

@export var pivot_num := 3
@export var scale_factor := 0.2
@export var scale_clamp := [0.1, 20.0]


@onready var box_list = {}

@onready var pivot_3 = [$orbital_zone/pivot_3/Node2D, $orbital_zone/pivot_3/Node2D2, $orbital_zone/pivot_3/Node2D3]
@onready var pivot_4 = [$orbital_zone/pivot_4/Node2D, $orbital_zone/pivot_4/Node2D2, $orbital_zone/pivot_4/Node2D3, $orbital_zone/pivot_4/Node2D4]
@onready var pivot_5 = [$orbital_zone/pivot_5/Node2D, $orbital_zone/pivot_5/Node2D2, $orbital_zone/pivot_5/Node2D3, $orbital_zone/pivot_5/Node2D4, $orbital_zone/pivot_5/Node2D5]
@onready var pivot_6 = [$orbital_zone/pivot_6/Node2D, $orbital_zone/pivot_6/Node2D2, $orbital_zone/pivot_6/Node2D3, $orbital_zone/pivot_6/Node2D4, $orbital_zone/pivot_6/Node2D5, $orbital_zone/pivot_6/Node2D6]

@onready var pivot = $orbital_zone/pivot_3

@onready var clouds := [pivot_3, pivot_4, pivot_5, pivot_6]

var tracked_box : Node2D


func _process(delta) -> void:
	_rotate_point_cloud(delta, 1.4)
	var begin_i = 0
	for box in box_list.keys():
		_calculate_box_logic(box_list[box], clouds[pivot_num - 3][begin_i].global_position, delta)
		begin_i += 1
	
	if tracked_box != null:
		_tracked_box(delta)

func _rotate_point_cloud(delta : float, mag : float) -> void:
	pivot.rotation += mag * delta

func _calculate_box_logic(box, target_point : Vector2, delta) -> void:
	box.position = lerp(box.position, target_point, 4.4 * delta)

func _tracked_box(delta: float):
	tracked_box.position = lerp(tracked_box.position, get_global_mouse_position(), 14.4 * delta)
	
	if Input.is_action_just_pressed("scrollUp"):
		tracked_box.scale *= scale_factor + 1 # lerp this eventually
	elif Input.is_action_just_pressed("scrollDown"):
		tracked_box.scale *= 1 - scale_factor # lerp eventually
	
	tracked_box.scale = Vector2(clampf(tracked_box.scale.x, scale_clamp[0], scale_clamp[1]), clampf(tracked_box.scale.y, scale_clamp[0], scale_clamp[1]))
	

# Signaled Functions
func _update_box_list(box, id) -> void:
	if box.get_meta("id") not in box_list.keys():
		box_list[id] = box
		tracked_box = null
	else:
		# remove box from list and create a reference to the box
		tracked_box = box_list[id]
		box_list.erase(id)
