extends Node2D

@export var cursor_asset := MeshInstance2D

func _process(delta):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_update_cursor_position(delta)

func _update_cursor_position(delta : float):
	cursor_asset.global_position = get_global_mouse_position()
