class_name Volume
extends Node


var mus_vol := 0.25
var sfx_vol := 0.25

func _process(delta: float) -> void:
	var screen = DisplayServer.window_get_mode()
	
	if Input.is_action_just_pressed("toggleFullScreen"):
		if screen == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
