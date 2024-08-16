extends Node2D

@export var target : Marker2D
@export var lerp_weight := 0.5

@onready var glowish: Sprite2D = $Area2D/glowish

var canClick := false
var moveBox := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	glowish.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if canClick and Input.is_action_just_pressed("leftClick"):
		moveBox = true
	
	if moveBox:
		transform_box(delta)
		moveBox = false

func transform_box(d: float):
	while self.global_position != target.global_position:
		self.global_position = lerp(self.global_position, target.global_position, lerp_weight * d)


# Signal Functions
func _on_area_2d_mouse_entered() -> void:
	glowish.visible = true
	canClick = true
	

func _on_area_2d_mouse_exited() -> void:
	glowish.visible = false
	canClick = false
