extends Node3D

var b_onVolante := false
var b_onMarcha := false
var f_robotRotation := 0.0
var f_currRotation = 0.0
var v3_controlesPos :Vector3

@onready var marchaCtrl: Node3D = $MarchaControler
@onready var volanteCtrl: Node3D = $VolanteControler

@onready var MeshControles: MeshInstance3D = $"../MODELS/BASE"

@onready var robot: CharacterBody3D = $"../../ROBOT"
@onready var robotCamPivot: Node3D = $"../../ROBOT/RobotCamPivot"
@onready var camera_robot: Camera3D = $"../../ROBOT/RobotView/CameraRobot"

var f_force := 0.0
var v3_dir := Vector3(0,0,0)


func _ready() -> void:
	v3_controlesPos = MeshControles.position

func _process(_delta: float) -> void:
	
	if   b_onVolante: ManageVolante()
	
	Movement()
	Shake()

func ManageVolante():
	robotCamPivot.rotation.y = -volanteCtrl.Estrvalue
	f_currRotation = -volanteCtrl.Estrvalue

func Movement():
	print(f_robotRotation + f_currRotation)
	rotation.y = f_robotRotation + f_currRotation
	f_force    = marchaCtrl.force
	v3_dir     = Vector3(
		-global_transform.basis.z.normalized().z,
		0, 
		global_transform.basis.z.normalized().x) 


func Shake():
	MeshControles.position = v3_controlesPos +\
	Vector3(randf_range(-1, 1) * 0.005 *  marchaCtrl.force, 0, 
			randf_range(-1, 1) * 0.005 *  marchaCtrl.force)


#region INPUT

func _on_input_volante() -> void:
	$VolanteControler.onControl = true
	b_onVolante = true
	
	f_robotRotation = rotation.y
	$VolanteControler/VolanteSonido.play()

func _on_input_marcha() -> void:
	marchaCtrl.onControl = true
	b_onMarcha = true
	#Set vars
	marchaCtrl.mouseStart = get_viewport().get_mouse_position()
	marchaCtrl.startAngle = marchaCtrl.GetMarchaAngle()

func _on_input_release() -> void:
	if b_onVolante:
		volanteCtrl.onControl = false
		b_onVolante = false
		$"../../ROBOT/RobotView/CameraRobot".self_rotationY += $"../../ROBOT/RobotCamPivot".rotation_degrees.y
		$"../../ROBOT/RobotCamPivot".rotation_degrees.y = 0.0
		$VolanteControler/VolanteSonido.volume_db = -80
	else:
		marchaCtrl.onControl = false
		b_onMarcha = false

#endregion
