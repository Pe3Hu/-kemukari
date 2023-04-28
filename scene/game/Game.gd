extends Node


func _ready() -> void:
	#Global.obj.kasino = Classes_0.Kasino.new()
	Global.obj.leinwand = Classes_1.Leinwand.new()
	Global.obj.planet = Classes_2.Planet.new()
	Global.obj.austausch = Classes_5.Austausch.new()
	#Global.obj.planet.obj.vorderseite.battle_preparation()
	
		
	for _i in 10000:
		Global.obj.planet.obj.vorderseite.next_turn()
			
#	datas.sort_custom(func(a, b): return a.value > b.value)


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				Global.obj.planet.obj.vorderseite.select_next_schlachtfeld(-1)
			KEY_D:
				Global.obj.planet.obj.vorderseite.select_next_schlachtfeld(1)
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					#Global.obj.planet.obj.vorderseite.next_turn()
					Global.obj.austausch.next_round()

func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
