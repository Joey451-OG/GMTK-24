extends Node2D

@onready var marker_2d: Marker2D = $Pivot_Point/Box_SnapPos
@onready var target_box : Node2D

var isHoldingBox := false
var isInPosition := false
var t_angle: float

signal send_package(Node2D)

func _process(delta):
	if Input.is_action_just_pressed("leftClick") and isHoldingBox:
		_fire_animation()
	_rotate_gun()
	_update_position(delta)
	t_angle = $Pivot_Point.rotation
	
	# Snapping box to marker pos
	if target_box != null:
		if !isInPosition:
			target_box.global_position = lerp(target_box.global_position, marker_2d.global_position, 4.4 * delta)
		else:
			target_box.global_position = marker_2d.global_position
		
		if (target_box.global_position.x - marker_2d.global_position.x) < 0.01:
			isInPosition = true

func _rotate_gun() -> void:
	$Pivot_Point.look_at(get_global_mouse_position())
func _update_position(delta : float) -> void:
	$Pivot_Point/Mesh.position = lerp($Pivot_Point/Mesh.position, Vector2(13.0,0.0), 4.0 * delta);

func _get_firing_angle() -> float:
	return t_angle
func _fire_animation() -> void:
	$Pivot_Point/Mesh.position -= Vector2(15.0,0.0)
func _get_fire_position()-> Marker2D:
	return $Pivot_Point/Bullet_Point

# signal functions
func _capture_box(box, id):
	if target_box == null:
		target_box = box
		isHoldingBox = true
		send_package.emit(box)

func _get_marker() -> Marker2D:
	return marker_2d

func _set_marker(m) -> void:
	marker_2d = m
