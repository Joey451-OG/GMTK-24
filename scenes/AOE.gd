extends Node2D

@onready var box_list = [$Box]

var point_cloud = []

func _ready() -> void:
	_gen_point_cloud(3)

func _process(delta) -> void:
	_update_box_list()
	for _box in box_list:
		_calculate_box_logic(_box)

func _gen_point_cloud(num_of_points: int) -> void:
	pass

func _calculate_box_logic(target) -> void:
	pass #logic for indevidual boxes...

func _update_box_list() -> void:
	pass #add boxes to box list when needed...
