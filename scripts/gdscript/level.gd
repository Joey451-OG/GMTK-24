extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _enimy_request_id(request_id) -> void:
	var target = instance_from_id(request_id)
	
	target._recive_answer($PlayerBody/AOE.list_old_ids[-1])
