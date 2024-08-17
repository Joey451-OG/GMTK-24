extends Node

# title.mp3 is a placeholder, maybe add a more ambient track later


signal bullet_time
var title_playback_position = 0

func _ready():
	play_title_theme()



func _process(delta):
	pass
	
func play_title_theme():
	$Title.play()


func _on_aoe_enter_bullet_time():
	# Strange bug: this function gets called repeatedly while in bullet time
	# need this condition to mitigate. fix emit call in AOE.gd later.
	if $Title.get_playback_position() > title_playback_position:    
		title_playback_position = $Title.get_playback_position()
		$BulletTimeLoop.play()
		$Title.stop()


func _on_aoe_exit_bullet_time():
	$Title.play(title_playback_position)
	title_playback_position = 0
	$BulletTimeLoop.stop()
