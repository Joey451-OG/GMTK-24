extends AnimatedSprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"."
@onready var player_body: CharacterBody2D = $".."

var isFacingRight := true

enum STATES {
	IDLE,
	WALK,
	JUMP,
}

var current_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Left"):
		current_state = STATES.WALK
		isFacingRight = false
	elif Input.is_action_pressed("Right"):
		current_state = STATES.WALK
		isFacingRight = true
	elif Input.is_action_pressed("Forward"):
		current_state = STATES.JUMP
	else:
		current_state = STATES.IDLE
	
	_switch_board()
	
func _switch_board():
	if !isFacingRight:
		self.flip_h = true
	else: 
		self.flip_h = false
	
	match current_state:
		STATES.WALK:
			if player_body.is_on_floor(): self.play("running")
			else: self.play("falling")
		STATES.JUMP:
			self.play("jump")
		STATES.IDLE:
			self.play("idle")
		
		
	
