extends CharacterBody3D

@onready var planet: StaticBody3D = $"../StaticBody3D"

const SPEED = 0.2
var gravity =1
var gravityDirection;
var distance = 0.6

func _physics_process(delta):
	gravityDirection = planet.position - position
	rotation = (Quaternion(-transform.basis.y, gravityDirection) * transform.basis.get_rotation_quaternion()).normalized().get_euler()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var direction = (global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity = direction * SPEED
	print(velocity)
	# Add the gravity.
	velocity += gravityDirection * gravity * delta
	#print(gravityDirection)
	#print(dist3(planet.position, position))
	move_and_slide()
	#setDistance()
