extends Node2D
@export var camera_zoom := Vector2(2.0, 2.0)
@export var cameras : Array[Camera2D]
@export var player : CharacterBody2D

var valid_ids = []
var section_index := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cameras[0].enabled = true
	valid_ids.append(player.get_instance_id())

func _on_next_0_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.get_instance_id() in valid_ids:
		valid_ids.append(body.get_instance_id())
		cameras[0].enabled = true
		cameras[1].enabled = false
	
	for cam in cameras:
		print(cam.enabled)

func _on_next_1(body: Node2D) -> void:
	if body.is_in_group("player") or body.get_instance_id() in valid_ids:
		valid_ids.append(body.get_instance_id())
		cameras[0].enabled = false
		cameras[1].enabled = true
	
	for cam in cameras:
		print(cam.enabled)
