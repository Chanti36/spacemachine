extends Node3D

var b_onVolante := false
var b_onMarcha := false
var f_robotRotation := 0.0
var f_currRotation = 0.0
var v3_controlesPos :Vector3
var v3_tub1Pos :Vector3
var v3_tub2Pos :Vector3
var v3_tub3Pos :Vector3
var v3_tub4Pos :Vector3
var v3_tub5Pos :Vector3

@onready var marchaCtrl: Node3D = $MarchaControler
@onready var volanteCtrl: Node3D = $VolanteControler

@onready var MeshControles: MeshInstance3D = $"../MODELS/BASE"
@onready var tub1: MeshInstance3D = $"../MODELS/PARED/Tubería_001"
@onready var tub2: MeshInstance3D = $"../MODELS/PARED/Tubería_002"
@onready var tub3: MeshInstance3D = $"../MODELS/PARED/Tubería_004"
@onready var tub4: MeshInstance3D = $"../MODELS/PARED/Tubería_005"
@onready var tub5: MeshInstance3D = $"../MODELS/PARED/Tubería_006"



@onready var robot: CharacterBody3D = $"../../animationparent/ROBOT"
@onready var robotCamPivot: Node3D = $"../../animationparent/ROBOT/RobotCamPivot"
@onready var camera_robot: Camera3D = $"../../animationparent/ROBOT/RobotView/CameraRobot"

var f_force := 0.0
var v3_dir := Vector3(0,0,0)


func _ready() -> void:
	v3_controlesPos = MeshControles.position
	v3_tub1Pos = tub1.position
	v3_tub2Pos = tub2.position
	v3_tub3Pos = tub3.position
	v3_tub4Pos = tub4.position
	v3_tub5Pos = tub5.position

func _process(_delta: float) -> void:
	
	if   b_onVolante: ManageVolante()
	
	Movement()
	Shake()

func ManageVolante():
	robotCamPivot.rotation.y = -volanteCtrl.Estrvalue*.4
	f_currRotation = -volanteCtrl.Estrvalue*.4

func Movement():
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
	tub1.position = v3_tub1Pos +\
	Vector3(randf_range(-1, 1) * 0.01 *  marchaCtrl.force, 0, 
			randf_range(-1, 1) * 0.01 *  marchaCtrl.force)
	tub2.position = v3_tub2Pos +\
	Vector3(randf_range(-1, 1) * 0.01 *  marchaCtrl.force, 0, 
			randf_range(-1, 1) * 0.01 *  marchaCtrl.force)
	tub3.position = v3_tub3Pos +\
	Vector3(randf_range(-1, 1) * 0.01 *  marchaCtrl.force, 0, 
			randf_range(-1, 1) * 0.01 *  marchaCtrl.force)
	tub4.position = v3_tub4Pos +\
	Vector3(randf_range(-1, 1) * 0.01 *  marchaCtrl.force, 0, 
			randf_range(-1, 1) * 0.01 *  marchaCtrl.force)
	tub5.position = v3_tub5Pos +\
	Vector3(randf_range(-1, 1) * 0.01 *  marchaCtrl.force, 0, 
			randf_range(-1, 1) * 0.01 *  marchaCtrl.force)


#region INPUT

func _on_input_volante() -> void:
	$VolanteControler.onControl = true
	b_onVolante = true
	
	f_robotRotation = rotation.y
	#$VolanteControler/VolanteSonido.play()

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
		$"../../animationparent/ROBOT/RobotView/CameraRobot".self_rotationY += $"../../animationparent/ROBOT/RobotCamPivot".rotation_degrees.y
		$"../../animationparent/ROBOT/RobotCamPivot".rotation_degrees.y = 0.0
		$VolanteControler/VolanteSonido.volume_db = -80
	else:
		marchaCtrl.onControl = false
		b_onMarcha = false

#endregion


func _on_ambient_finished() -> void:
	$ambient.play()
