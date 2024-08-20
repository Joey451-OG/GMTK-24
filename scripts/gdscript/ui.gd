extends CanvasLayer
 
@export var main_menu := CanvasGroup 
@export var level_menu := CanvasGroup 
@export var settings_menu := CanvasGroup 

var volume_v: float

signal send_mus(val : float)
signal send_sfx(val : float)

func _ready():
	volume_v = 1.0

func _process(delta):
	pass

func _play():
	get_tree().change_scene_to_file("res://levels/level0.tscn")

func _load_level_0():
	get_tree().change_scene_to_file("res://levels/level0.tscn")

func _load_level_1():
	get_tree().change_scene_to_file("res://levels/level1.tscn")

func _load_level_2():
	get_tree().change_scene_to_file("res://levels/level2.tscn")

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
	


func _on_button_1_hover():
	pass

func _on_button_2_hover():
	pass
	
func _on_button_3_hover():
	pass
	
func _on_button_4_hover():
	pass
	
func _on_button_5_hover():
	pass

func _on_button_6_hover():
	pass
	
func _on_button_7_hover():
	pass

func _on_button_8_hover():
	pass


func _on_level_mouse_entered():
	pass # Replace with function body.


func _on_music_value_changed(value: float) -> void:
	VolumeSingleton.mus_vol = value
	send_mus.emit(value)

func _on_sfx_value_changed(value: float) -> void:
	VolumeSingleton.sfx_vol = value
	send_sfx.emit(value)
