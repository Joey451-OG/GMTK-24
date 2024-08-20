extends Node

@onready var mus_bus := AudioServer.get_bus_index("music")
@onready var sfx_bus := AudioServer.get_bus_index("sfx")

var current_scene : String
var doVolUpdates := false

func _ready():
	mus(linear_to_db(VolumeSingleton.mus_vol))
	sfx(linear_to_db(VolumeSingleton.sfx_vol))
	
	current_scene = get_tree().current_scene.scene_file_path

	if current_scene == "res://scenes/UI.tscn":
		$TwoMediumTwoToppingPizzasWithDoublePepperoni.play()
		doVolUpdates = true
	elif current_scene == "res://levels/level0.tscn":
		$Level0.play()
	elif current_scene == "res://levels/level1.tscn":
		$Level1.play()
	elif current_scene == "res://levels/level2.tscn":
		$Level2.play()
	elif current_scene == "res://levels/credits.tscn":
		$AvecaStampCollectingRobot.play()
	
	var family = self.get_children()
	
	for child in family:
		child.max_distance = 100000000000
		child.panning_strength = 0

func _process(delta: float) -> void:
	
	print(VolumeSingleton.mus_vol)
	print(VolumeSingleton.sfx_vol)
	
	print(AudioServer.get_bus_name(0))
	print(AudioServer.get_bus_volume_db(0))
	print(AudioServer.get_bus_name(1))
	print(AudioServer.get_bus_volume_db(1))
	print(AudioServer.get_bus_name(2))
	print(AudioServer.get_bus_volume_db(2))

func _play_throw():
	$Throwedit.play()

func _play_jump():
	$Jump.play()
	
func _play_hit():
	$Hit.play()

func sfx(db: float):
	AudioServer.set_bus_volume_db(sfx_bus, db)

func mus(db: float):
	AudioServer.set_bus_volume_db(mus_bus, db)

# Random, I swear to god why did you have to name your song this
func _on_two_medium_two_topping_pizzas_with_double_pepperoni_finished() -> void:
	$TwoMediumTwoToppingPizzasWithDoublePepperoni.play()

func _on_root_send_mus(val: float) -> void:
	mus(linear_to_db(val))

func _on_root_send_sfx(val: float) -> void:
	sfx(linear_to_db(val))
