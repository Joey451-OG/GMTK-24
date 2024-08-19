extends Camera2D
@export var camera_zoom := Vector2(2.0, 2.0)
@export var clamp_list_x : Array[Vector2]
@export var clamp_list_y : Array[Vector2]
@export var player : CharacterBody2D

enum STATES {
	SCROLL,
	ROOM
}

var camera_state := STATES.SCROLL
var section_index := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match camera_state:
		STATES.SCROLL:
			_scroll()
		
		STATES.ROOM:
			_room()

func _scroll():
	#self.position = player.position
	#self.position.x = clamp(self.position.x, clamp_list_x[section_index][0], clamp_list_x[section_index][0])
	#self.position.y = clamp(self.position.y, clamp_list_y[section_index][0], clamp_list_y[section_index][1])
	pass
	
func _room():
	pass
