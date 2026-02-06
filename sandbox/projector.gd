extends SpotLight3D

func _process(delta: float) -> void:
	rotate(Vector3.UP, delta/10.0)
