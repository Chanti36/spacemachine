extends CharacterBody3D

@onready var playerCtrl: Node3D = $"../CONTROL/PlayerControler"
@onready var world: MeshInstance3D = $"../WORLD/planetMesh"

var speed = 5
var gravity = 1
var gravityDirection;
var distance = 0.6

func _physics_process(delta: float) -> void:
	gravityDirection = world.position - position
	rotation = (Quaternion(-transform.basis.y, gravityDirection) * transform.basis.get_rotation_quaternion()).normalized().get_euler()
	
	var dir = (global_basis * playerCtrl.v3_dir).normalized()
	# Get the input direction and handle the movement/deceleration.
	if playerCtrl.f_force > 0.1:
		var direction = (global_basis * playerCtrl.v3_dir * playerCtrl.f_force).normalized()
		velocity = direction * -speed
		# Add the gravity.
		velocity += gravityDirection * gravity * delta
	else:
		velocity = Vector3.ZERO
	move_and_slide()

func dist3(from : Vector3, to : Vector3):
	var v = from - to
	var d = sqrt(
	v.x *  v.x
	+ v.y * v.y
	+ v.z * v.z)
	return d
