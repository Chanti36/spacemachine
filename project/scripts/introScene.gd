extends Control

var txt := "OUTER SPACE WAS NO MEANT FOR US"
var txt1 := "The first astromobile has 
been successfully sent into space"
var txt2 := "BE KIND"

#cada vez que cambia el texto se vuelve más pequeñp y en el último más grande

@onready var label: Label = $Control/Label
var txtTimer := -2.0
var txtIndex := 0
var scaleVal := 0.0

func _ready() -> void:
	label.text = txt
	$AnimationPlayer.play("startr")

func _process(delta: float) -> void:
	txtTimer += delta
	scaleVal += delta
	$Control.scale = Vector2(1 + (scaleVal * 0.005), 1 + (scaleVal * 0.005))
	
	if (txtTimer > 4):
		txtTimer = 0.0
		txtIndex += 1
		
		if txtIndex == 1:
			label.text = txt1
		if txtIndex == 2:
			label.text = txt2
		if txtIndex == 3:
			get_tree().change_scene_to_file("res://scenes/mainscene.tscn")

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && txtTimer < 3.8:
			txtTimer = 5
