extends Node

var fatal_hit_effect = preload("res://scenes/fatal_hit_effect.tscn")
var dull_hit_effect = preload("res://scenes/dull_hit_effect.tscn")

func _on_body_entered(body):
	if !body.is_in_group("baddies") and body != self:
		if body.is_in_group("player"):
			var f_hit = fatal_hit_effect.instantiate()
			get_tree().root.add_child(f_hit)
			f_hit.global_position = self.global_position
			f_hit.emitting = true
			self.queue_free()
		else:
			var d_hit = dull_hit_effect.instantiate()
			get_tree().root.add_child(d_hit)
			d_hit.global_position = self.global_position
			d_hit.emitting = true
			self.queue_free()
