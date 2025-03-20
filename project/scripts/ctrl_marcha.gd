extends Node3D

var onControl := false
var mouseStart :Vector2
var mousePosition :Vector2
var startAngle := -30.0

var distance := 0.0
var angle := 0.0
var force := 0.0

@onready var marcha: MeshInstance3D = $"../../MODELS/BASE/Marcha/Marcha"
@onready var rueda_pal: MeshInstance3D = $"../../MODELS/BASE/Marcha/RuedaPal"

func _process(_delta: float) -> void:
	if !onControl:
		return
		
	mousePosition = get_viewport().get_mouse_position()
	distance = (mousePosition.y - mouseStart.y) / 500
	if distance > 1 : distance = 1
	if distance < -1 : distance = -1
	
	if distance >= 0:	angle = lerp(startAngle, -30.0, distance)
	if distance < 0:	angle = lerp(startAngle, 30.0, -distance)

	#-30-30
	marcha.rotation_degrees = Vector3(angle, 0, 90)
	rueda_pal.rotation_degrees = Vector3(angle, 0, 0)
	
	if (angle < 0):
		force = 0.5 + (0.5 * (angle / 30))
	else:
		force = 0.5 + (angle / 60)
		
	if force < 0:
		force = 0
	$EngineSonido.volume_db = (force - 1) * 50

func GetMarchaAngle():
	return marcha.rotation_degrees.x


func _on_engine_sonido_finished() -> void:
	$EngineSonido.play()
