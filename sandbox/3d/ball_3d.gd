class_name Ball3D
extends RigidBody3D

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("fling"):
		apply_impulse(Vector3(0.0, 1.0, -0.5) * 5.0, Vector3.DOWN * randf_range(0.09, 0.11))
	if Input.is_action_pressed("spin"):
		spin()
		
func spin() -> void:
	apply_torque_impulse(Vector3.RIGHT)
