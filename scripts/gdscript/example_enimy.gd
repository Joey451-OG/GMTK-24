extends Area2D
var self_area: Area2D
var recived_id: int

signal request_id(ObjectID : int)

func _ready():
	request_id.emit(get_instance_id())


func _on_box_area_entered(box, inID) -> void:
	if box.get_meta("isFired"):
		print("DAMAGE DEALT")
