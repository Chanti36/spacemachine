extends Node3D

var onControl := false

@onready var volante: Node3D = $"../../MODELS/BASE/Volante/Volante"
@onready var steerCenter: ColorRect = $"../../../Virtual/SteerPivot"

var prevSteerDotVal := 0.0
var currSteerDotVal := 0.0
var startRotation := 0.0

#Cstr for steering controller Estr for steering gdengine
var Cstrmax
var Cstrvalue := 0.0
var Estrmax
var Estrvalue

var lastMousepos := Vector2(0,0)

#Called when the node enters the scene tree for the first time.
func _ready():
	Cstrmax = 18
	Estrmax = 2

func StartSteer():
	var mousePos = get_viewport().get_mouse_position() - steerCenter.position
	prevSteerDotVal = calc_dot_product(Vector2.UP, mousePos)
	startRotation = volante.rotation.z
	Estrvalue = 0
	Cstrvalue = 0

func _process(delta):
	if !onControl:
		return
	SteerCtrl(delta)

func SteerCtrl(delta):
	var  steerRotUpdateVal = 0
	var mousePos = get_viewport().get_mouse_position() - steerCenter.position
	
	if lastMousepos.distance_to(mousePos) > 1:
		if $VolanteSonido.volume_db < -10:
			$VolanteSonido.volume_db += delta * 50
	else:
		$VolanteSonido.volume_db = -80
	
	
	currSteerDotVal = calc_dot_product(Vector2.UP, mousePos)
	steerRotUpdateVal = currSteerDotVal - prevSteerDotVal
	
	if get_mouse_quarant(mousePos) == 1 or \
	   get_mouse_quarant(mousePos) == 4:
		Cstrvalue -= steerRotUpdateVal * .025
	else:
		Cstrvalue += steerRotUpdateVal * .025
	Cstrvalue = clamp(Cstrvalue,-Cstrmax, Cstrmax)
	
	Estrvalue = (Estrmax * Cstrvalue) / Cstrmax
	
	prevSteerDotVal = currSteerDotVal
	
	volante.rotation = Vector3(
		0,
		0,
	startRotation - Estrvalue)
	lastMousepos = mousePos

func GetRotationAngle():
	return (volante.rotation_degrees.z)

#region Side funcs

func calc_dot_product(cadinalVec:Vector2, positionalVec:Vector2):
	cadinalVec.normalized();positionalVec.normalized()
	return cadinalVec.dot(positionalVec)

func get_mouse_quarant(mouse_vector:Vector2):
	if   mouse_vector.x > 0 and mouse_vector.y < 0:		return 1
	elif mouse_vector.x < 0 and mouse_vector.y < 0:		return 2
	elif mouse_vector.x < 0 and mouse_vector.y > 0:		return 3
	else:												return 4
#endregion


func _on_audio_finished() -> void:
	$VolanteSonido.play()
