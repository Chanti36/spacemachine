extends Camera3D

var self_rotationY : float
@onready var robot: CharacterBody3D = $"../.."

@onready var cam_pivot: Node3D = $"../../RobotCamPivot"

func _ready() -> void:
	self_rotationY = rotation_degrees.y

func _process(_delta: float) -> void:
	position = cam_pivot.global_position
	rotation_degrees = robot.rotation_degrees
	rotation_degrees.z += 90
	rotate_object_local(Vector3(1,0,0), deg_to_rad(self_rotationY) + deg_to_rad(cam_pivot.rotation_degrees.y))
	#print("A: ", deg_to_rad(self_rotationY) ," // B: ", deg_to_rad(cam_pivot.rotation_degrees.y))
	#y = self_rotation.y + robot_cam_transform.rotation_degrees.y
