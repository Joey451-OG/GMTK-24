extends Node

@export var volume = 2
signal bullet_time

var savedPlaybackPosition = 0
var last_playback_position = 0
var trackChoice
var options

func _ready():
	populate_options_list()
	choose_track(volume)
	play_title_theme()



func _process(delta):
	if trackChoice.get_playback_position() < last_playback_position:
		choose_track(volume)
	
func play_title_theme():
	trackChoice.play()

func choose_track(db: float):
	options = self.get_children()
	options.remove_at(0) # do not include AvecaBulletTimeLoop
	trackChoice = options[randi() % len(options)]
	trackChoice.volume_db = db

func _on_aoe_enter_bullet_time():
	# Strange bug: this function gets called repeatedly while in bullet time
	# need this condition to mitigate. fix emit call in AOE.gd later.
	if trackChoice.get_playback_position() > savedPlaybackPosition:
		savedPlaybackPosition = trackChoice.get_playback_position()
		$AvecaBulletTimeLoop.volume_db = volume
		$AvecaBulletTimeLoop.play()
		trackChoice.stop()

func create_audio_stream_player(resource_path: String):
	var audioStreamPlayer = AudioStreamPlayer.new()
	var audioStreamMP3 = load_mp3(resource_path)
	audioStreamPlayer.stream = audioStreamMP3
	audioStreamPlayer.set_name(resource_path.split(".")[0].split("/")[-1])
	
	add_child(audioStreamPlayer)

func populate_options_list():
	var audioFiles = DirAccess.get_files_at("res://music")
	for file in audioFiles:
		if (file.split(".")[-1] == "mp3"):
			create_audio_stream_player("res://music/" + file)
			print("res://music/" + file)


# this is copied from the godot docs
func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound

func _on_aoe_exit_bullet_time():
	trackChoice.play(savedPlaybackPosition)
	savedPlaybackPosition = 0
	$AvecaBulletTimeLoop.stop()
