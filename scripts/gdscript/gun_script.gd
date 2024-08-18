extends Node2D

var t_angle: float

func _process(delta):
	if Input.is_action_just_pressed("leftClick"):
		_fire_animation()
	_rotate_gun()
	_update_position(delta)
	t_angle = $Pivot.rotation

func _rotate_gun() -> void:
	$Pivot.look_at(get_global_mouse_position())
func _update_position(delta : float) -> void:
	$Pivot/Mesh.position = lerp($Pivot/Mesh.position, Vector2(13.0,0.0), 4.0 * delta);

func _get_firing_angle() -> float:
	return t_angle
func _fire_animation() -> void:
	$Pivot/Mesh.position -= Vector2(15.0,0.0)
func _get_fire_position()-> Marker2D:
	return $Pivot/Bullet_Point
