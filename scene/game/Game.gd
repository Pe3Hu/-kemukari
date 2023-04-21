extends Node


func _ready() -> void:
	Global.obj.kasino = Classes_0.Kasino.new()
	Global.obj.leinwand = Classes_1.Leinwand.new()
#	datas.sort_custom(func(a, b): return a.value > b.value)


func _input(event) -> void:
	if event is InputEventMouseButton:
		Global.mouse_pressed = !Global.mouse_pressed
	else:
		Global.mouse_pressed = !Global.mouse_pressed


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
