extends Node2D

@onready var box_list = [$Box]
@onready var point_cloud = [
$orbital_zone/pivot/Node2D, 
$orbital_zone/pivot/Node2D2,
$orbital_zone/pivot/Node2D3, 
$orbital_zone/pivot/Node2D4, 
$orbital_zone/pivot/Node2D5, 
$orbital_zone/pivot/Node2D6, 
$orbital_zone/pivot/Node2D7, 
$orbital_zone/pivot/Node2D8
]

@onready var pivot = $orbital_zone/pivot

func _process(delta) -> void:
	_update_box_list()
	_rotate_point_cloud(delta, 1.4)
	for _box in box_list:
		_calculate_box_logic(_box, point_cloud[0].global_position, delta)

func _rotate_point_cloud(delta : float, mag : float) -> void:
	pivot.rotation+=mag*delta

func _calculate_box_logic(box, target_point : Vector2, delta) -> void:
	box.position=lerp(box.position, target_point, 4.4*delta)

func _update_box_list() -> void:
	pass #add boxes to box list when needed...
