extends CharacterBody3D

@onready var playerCtrl: Node3D = $"../../CONTROL/PlayerControler"
@onready var world: MeshInstance3D = $"../../WORLD/planetMesh"

var speed = 5
var gravity = 1
var gravityDirection;
var distance := 0.6

var b_canmove := true
var b_onending := false
var f_endingtimer := 0.0
var originalpos := Vector3(0,0,0)
var originalangle := Vector3(0,0,0)
var desiredpos := Vector3(0,0,0)
var desiredangle := Vector3(0,0,0)

func _physics_process(delta: float) -> void:
	print(global_position)
	if b_onending:
		placeforending(delta)
	
	if !b_canmove:
		return
	gravityDirection = world.position - position
	rotation = (Quaternion(-transform.basis.y, gravityDirection) * transform.basis.get_rotation_quaternion()).normalized().get_euler()
	
	velocity = Vector3.ZERO
	if playerCtrl.f_force > 0.1:
		var direction = (global_basis * playerCtrl.v3_dir).normalized()
		velocity = direction * -speed * playerCtrl.f_force * 0.3
		# Add the gravity.
		velocity += gravityDirection * gravity * delta

	move_and_slide()

func dist3(from : Vector3, to : Vector3):
	var v = from - to
	var d = sqrt(
	v.x *  v.x
	+ v.y * v.y
	+ v.z * v.z)
	return d

func placeforending(_delta: float):
	#f_endingtimer += (delta * .5)
	#if f_endingtimer < 1:
		#$RobotCamPivot.global_rotation = originalangle.lerp(desiredangle, f_endingtimer)
		#global_position = originalpos.lerp(desiredpos, f_endingtimer)
	#else:
		#$RobotCamPivot.global_rotation = desiredangle
		#global_position = desiredpos
		##animation
		#b_onending = false
		
	$"../../AnimationPlayer".play("ending")
 
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "ROBOT":
		$"../../CONTROL/PlayerControler/RadioControler".working = false
		b_canmove = false
		originalpos = global_position
		originalangle = $RobotCamPivot.global_rotation
		desiredpos = Vector3(47.90281, -7.273131, 17.54568)
		desiredangle = Vector3(-1.570796, -1.948142, 0)
		b_onending = true
		#shut down radio
