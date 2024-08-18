extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var target_box : Node2D

var isHoldingBox := false
var isInPosition := false


func _capture_box(box, id):
	if target_box == null:
		target_box = box
		isHoldingBox = true

func _process(delta: float) -> void:
	if target_box != null:
		if !isInPosition:
			target_box.global_position = lerp(target_box.global_position, marker_2d.global_position, 4.4 * delta)
		else:
			target_box.global_position = marker_2d.global_position
		
		if (target_box.global_position.x - marker_2d.global_position.x) < 0.01:
			isInPosition = true
