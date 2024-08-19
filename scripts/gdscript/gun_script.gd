extends Node2D

@onready var marker_2d: Marker2D = $Pivot_Point/Box_SnapPos
@onready var target_box : Node2D

var isInPosition := false
var wasAnimationPlayed := false
var t_angle: float
var marks = {}

signal send_package(Node2D)

func _process(delta):
	_rotate_gun()
	_update_position(delta)
	t_angle = $Pivot_Point.rotation
	
	# Snapping box to marker pos
	if target_box != null and !target_box.get_meta("isThrown"):
		if !isInPosition:
			target_box.global_position = lerp(target_box.global_position, marker_2d.global_position, 7.4 * delta)
		else:
			target_box.global_position = marker_2d.global_position
		
		if (target_box.global_position.x - marker_2d.global_position.x) < 0.01 and not isInPosition:
			isInPosition = true

func _rotate_gun() -> void:
	$Pivot_Point.look_at(get_global_mouse_position())

func _update_position(delta : float) -> void:
	$Pivot_Point/Mesh.position = lerp($Pivot_Point/Mesh.position, Vector2(53.0,0.0), 4.0 * delta);

func _get_fire_vector() -> Vector2:
	return -(self.global_position - get_global_mouse_position())/self.global_position.distance_to(get_global_mouse_position()) # this is normalized

func _get_firing_angle() -> float:
	return t_angle
	
func _fire_animation() -> void:
	if !wasAnimationPlayed: # hacky solution to stop the animation from playing until the bullet is fired [see level.gd _fire_projectile()] -Joey 
		$Pivot_Point/Mesh.position -= Vector2(15.0,0.0)
		wasAnimationPlayed = true

func _get_fire_position()-> Marker2D: # Orphaned code, it's being used atm -Joey
	return $Pivot_Point/Bullet_Point

# signal functions
func _capture_box(box):
	if target_box == null:
		target_box = box
		target_box.set_meta("isFired", true)
		send_package.emit(box) # send out a reference to the target_block
		
		# hard coded meta data system since the godot one kept shitting the bed
		if target_box.get_instance_id() in marks.keys():
			marker_2d.position.x = marks[target_box.get_instance_id()]
		else:
			marker_2d.position.x = 90.0
		
func _get_marker() -> Marker2D:
	return marker_2d

func _set_marker(m) -> void:
	marker_2d = m
