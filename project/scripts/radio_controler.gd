extends Node3D

@onready var robot: CharacterBody3D = $"../../../animationparent/ROBOT"
@onready var angel: MeshInstance3D = $"../../../WORLD/Angel"
@onready var radioLight: SpotLight3D = $"../../SpotLight3D5"
@onready var radioSonido: AudioStreamPlayer3D = $RadioSonido

var distance:=0.0
var value := 0.0

var delaytimer:= 0.0
var worktimer := 0.0

var delaytime := 0.0
var worktime  := 0.0
var onwork := false
var working := true
func _ready() -> void:
	radioSonido.volume_db = -100
	radioLight.visible = false

func _process(delta: float) -> void:
	if !working:
		$RadioSonido.volume_db = -100
		return
	distance = robot.global_position.distance_squared_to(angel.global_position)
	
	if distance > 5000:
		delaytime = 50
		worktime = 0
	elif distance < 500:
		delaytime = 0
		worktime = 50
	else:
		value = 1 - ((distance - 500) / 5000)	
		if   value < .1:		delaytime =   5; worktime = .1
		elif value < .2:		delaytime =   4; worktime = .3
		elif value < .3:		delaytime = 3.5; worktime = .6
		elif value < .4:		delaytime =   3; worktime = 1
		elif value < .5:		delaytime = 2.5; worktime = 1.5
		elif value < .6:		delaytime =   2; worktime = 2.3
		elif value < .7:		delaytime =   1; worktime = 2.8
		elif value < .8:		delaytime =  .8; worktime = 3.5
		elif value < .9:		delaytime =  .6; worktime = 3
		else:					delaytime =  .4; worktime = 4
	
	worktimer  += delta
	delaytimer += delta
	
	if onwork:
		if worktimer > worktime:
			delaytimer = 0.0
			onwork = false
			radioSonido.volume_db = -100
			radioLight.visible = false
	else:
		if delaytimer > delaytime:
			worktimer = 0.0
			onwork = true
			radioSonido.volume_db = -20
			radioLight.visible = true
	

func _on_radio_sonido_finished() -> void:
	$RadioSonido.play()
