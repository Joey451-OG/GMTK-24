extends Node2D
@export var camera_zoom := Vector2(2.0, 2.0)
@export var cameras : Array[Camera2D]
@export var player : CharacterBody2D

var valid_ids = []
var section_index := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cameras[0].enabled = true


# Change Levels
func _to_level_1(body: Node2D):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://levels/level1.tscn")

func _to_level_2(body: Node2D):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://levels/level2.tscn")


# Change Cameras

func _change_camera(index: int):
	for i in range(cameras.size()):
		if i == index:
			cameras[i].enabled = true
		else:
			cameras[i].enabled = false

func _on_camera_area_entered(body: Node2D, enable_index: int) -> void:
	if body.is_in_group("player"):
		_change_camera(enable_index)
	
	for cam in cameras:
		print(cam.enabled)


func _on_death_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): player._kill()
