extends Node2D

@onready var glowish: Sprite2D = $Area2D/CollisionShape2D2/glowish
@onready var id = randi()

var canClick = false

signal clicked(Node2D, int)
signal area_entered(box, instance_id)

func _ready():
	glowish.visible = false
	
func _process(delta: float) -> void:
	if canClick and Input.is_action_just_pressed("leftClick"):
		if self.get_meta("id") == null || self.get_meta("id") == 0:
			self.set_meta("id", id)
			clicked.emit(self, id) 
		else:
			clicked.emit(self, self.get_meta("id"))
		
		print("CLICKED BOX:", self.get_meta("id"))
	

func _on_area_2d_mouse_entered() -> void:
	glowish.visible = true
	canClick = true

func _on_area_2d_mouse_exited() -> void:
	glowish.visible = false
	canClick = false
	

func _hit_box_area_entered(area: Area2D) -> void:
	area_entered.emit(self, get_instance_id())
