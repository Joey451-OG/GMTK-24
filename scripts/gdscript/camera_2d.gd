extends Node2D
@export var camera_zoom := Vector2(2.0, 2.0)
@export var cameras : Array[Camera2D]
@export var player : CharacterBody2D

var section_index := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_next_1(body: Node2D) -> void:
	if body.is_in_group("player"):	
		cameras[0].enabled = false
		cameras[0].enabled = true
