extends AnimatedSprite2D

enum STATES {
	IDLE,
	ATTACK,
}

var current_state := STATES.IDLE

func _process(delta: float) -> void:
	match current_state:
		STATES.IDLE:
			self.play("idle")
		STATES.ATTACK:
			self.play("attack")
