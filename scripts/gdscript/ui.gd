extends CanvasLayer
 
@export var main_menu := CanvasGroup 
@export var level_menu := CanvasGroup 
@export var settings_menu := CanvasGroup 

func _process(delta):
	pass

func _play():
	get_tree().change_scene_to_file("res://levels/level0.tscn")

func _load_level_0():
	get_tree().change_scene_to_file("res://levels/level0.tscn")

func _load_level_1():
	get_tree().change_scene_to_file("res://levels/level0.tscn")

func _load_level_2():
	get_tree().change_scene_to_file("res://levels/level0.tscn")

func _settings():
	level_menu.visible = false
	main_menu.visible = false
	settings_menu.visible = true

func _level_select():
	settings_menu.visible = false
	main_menu.visible = false
	level_menu.visible = true
	
func _back():
	main_menu.visible = true
	level_menu.visible = false
	settings_menu.visible = false

func _full_screen():
	pass

func _windowed(boolean):
	if boolean:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
