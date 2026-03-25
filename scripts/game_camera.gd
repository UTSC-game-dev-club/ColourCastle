extends Camera3D

class_name GameCamera

func transition_to_sidescroller() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(self, "position", Vector3(0, 15, 50), 0.8)
	tween.parallel().tween_property(self, "rotation", Vector3(0, 0, 0), 0.8)
	
	await tween.finished

func transition_to_topdown() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(self, "position", Vector3(0, 50, 15), 0.8)
	tween.parallel().tween_property(self, "rotation", Vector3(-PI / 2, 0, 0), 0.8)
	
	await tween.finished
