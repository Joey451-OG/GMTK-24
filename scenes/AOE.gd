extends Node2D

@export var distance_from_center := 5

@onready var box_list = [$Box, $Box2, $Box3]
var point_cloud = []
var addedChildren = false

func _ready() -> void:
	_gen_point_cloud(3, 1)

func _process(delta) -> void:
	_update_box_list()
	for _box in box_list:
		_calculate_box_logic(_box)
	_gen_point_cloud(3, 1000)

func _gen_point_cloud(num_of_points: int, temp) -> void:
	var distance = 360 / num_of_points
	var starting_angle = 0
	
	for i in range(num_of_points):
		point_cloud.append(Marker2D.new())
		if !addedChildren:
			self.add_child(point_cloud[i])
		point_cloud[i].position = Vector2(distance_from_center * cos(deg_to_rad(starting_angle)),
								 -(distance_from_center * sin(deg_to_rad(starting_angle))))
		starting_angle += distance
	
	addedChildren = true
	starting_angle = 0
	starting_angle += temp
		

func _calculate_box_logic(target) -> void:
	box_list[0].position = point_cloud[0].position

func _update_box_list() -> void:
	pass #add boxes to box list when needed...
