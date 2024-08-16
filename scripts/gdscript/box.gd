extends Node2D

@onready var glowish: Sprite2D = $Area2D/glowish
var canClick = false

signal clicked(Node2D, int)

func _ready():
	glowish.visible = false
	
func _process(delta: float) -> void:
	if canClick and Input.is_action_just_pressed("leftClick"):
		if self.get_meta("id") == null:
			var id = randi()
			self.set_meta("id", id)
			clicked.emit(self, id)
		else:
			clicked.emit(self, self.get_meta("id"))
	

func _on_area_2d_mouse_entered() -> void:
	glowish.visible = true
	canClick = true
	

func _on_area_2d_mouse_exited() -> void:
	glowish.visible = false
	canClick = false
