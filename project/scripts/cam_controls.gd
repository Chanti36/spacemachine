extends Camera3D

var mousePos : Vector2
var viewportSize : Vector2
var mouseSection := 1
var camLerp := 1.0
var fromAngle := 180.0
var toAngle := 180.0
var lerpAngle := 180.0
var clickPressed := false
var overWheel := false
var overSteer := false

func _ready() -> void:
	viewportSize = get_viewport().size
	mousePos = get_viewport().get_mouse_position()
	if mousePos.x < viewportSize.x * 0.33:
		mouseSection = 0
	elif mousePos.x < viewportSize.x * 0.66:
		mouseSection = 1
	else:
		mouseSection = 2

func _process(delta: float) -> void:
	mousePos = get_viewport().get_mouse_position()
	CamTilt(delta)

func _input(event):
	# Mouse in viewport coordinates.	
	if event is InputEventMouseButton :
		if event.is_pressed():
			clickPressed = true
			if overWheel:
				$"../PlayerControler/VolanteControler".StartSteer()
				INPUT_VOLANTE.emit()
			elif overSteer:
				INPUT_MARCHA.emit()
		else:
			RELEASE.emit()
			clickPressed = false


#region Input Areas
func _on_area_marcha_mouse_entered() -> void:
	overSteer = true

func _on_area_volante_mouse_entered() -> void:
	overWheel = true


func _on_area_marcha_mouse_exited() -> void:
	overSteer = false

func _on_area_volante_mouse_exited() -> void:
	overWheel = false

#endregion

#movimiento de la camara en funcion a donde mire
#1/5 izq 3/5 medio 5/5 der // 2/5 y 4/5 se mantiene el q tenga
func CamTilt(delta):
	if clickPressed:
		camLerp = 2
		return
	
	if mousePos.x < ((viewportSize.x / 5)):
		if mouseSection != 0:
			mouseSection = 0
			camLerp = 0.0
			fromAngle = rotation_degrees.y
			toAngle = 195
	elif mousePos.x > ((viewportSize.x / 5) * 2) && mousePos.x < ((viewportSize.x / 5) * 3):
		if mouseSection != 1:
			mouseSection = 1
			camLerp = 0.0
			fromAngle = rotation_degrees.y
			toAngle = 180
	elif mousePos.x > ((viewportSize.x / 5) * 4):
		if mouseSection != 2:
			mouseSection = 2
			camLerp = 0.0
			fromAngle = rotation_degrees.y
			toAngle = 165
			
	if camLerp > 1:
		return
	
	camLerp += (delta)
	#with lerp delta arriba estaba *3 y los angulos eran 185 y 175 (10 menos de distnacia)
	lerpAngle = move_toward (fromAngle, toAngle, camLerp)
	rotation_degrees = Vector3(0, lerpAngle, 0)

#activar el control sobre el que ha pulsado
#func checkControl():
	#var rayLength = 1000
	#
	#var from = project_ray_origin(mousePos)
	#var to = from + project_ray_normal(mousePos) * rayLength
	#var space = get_world_3d().direct_space_state
#
	#var rayquery = PhysicsRayQueryParameters3D.new()
	#rayquery.from = from
	#rayquery.to = to
#
	#var raycastResult = space.intersect_ray(rayquery)
	#
	#if !raycastResult.is_empty():
		#if raycastResult.get("collider").get_parent_node_3d().name == "Volante":
			#print("Volante")
			#$"../PlayerControler/VolanteControler".StartSteer()
			#INPUT_VOLANTE.emit()
		#elif raycastResult.get("collider").get_parent_node_3d().name == "Marcha":
			#print("Marcha")
			#INPUT_MARCHA.emit()

signal INPUT_VOLANTE()
signal INPUT_MARCHA()
signal RELEASE()
