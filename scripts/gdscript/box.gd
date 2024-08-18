extends Node2D

@onready var glowish: Sprite2D = $Area2D/CollisionShape2D2/glowish
@onready var id = randi()
@onready var range := 200.0
@export var PlayerBody : CharacterBody2D

var canClick = false
var distance_to_mouse : float

signal clicked(Node2D)
signal area_entered(box: Node2D, instance_id: int)

func _ready():
	glowish.visible = false
	
	# contrustors for metadata
	self.set_meta("isThrown", false)
	self.set_meta("isFired", false)
	
func _process(delta: float) -> void:
	distance_to_mouse = PlayerBody.global_position.distance_to(get_global_mouse_position())
	
	if canClick and Input.is_action_just_pressed("leftClick"):
		if distance_to_mouse < range: 
			clicked.emit(self) 
		
	

# signal functions

func _on_area_2d_mouse_entered() -> void:
	if distance_to_mouse < range:
		glowish.visible = true
	canClick = true

func _on_area_2d_mouse_exited() -> void:
	if distance_to_mouse < range:
		glowish.visible = false
	canClick = false
	
func _hit_box_area_entered(area: Area2D) -> void:
	area_entered.emit(self, get_instance_id())
