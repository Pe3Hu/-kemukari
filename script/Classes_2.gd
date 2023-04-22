extends Node


#Сектор
class Sektor:
	var word = {}
	var vec = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.owner = input_.owner
		vec.grid = input_.grid
		obj.schlachtfeld = input_.schlachtfeld
		obj.nachzucht = null
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.sektor.instantiate()
		obj.schlachtfeld.scene.myself.add_child(scene.myself)
		scene.myself.set_status(self)


#Поле боя
class Schlachtfeld:
	var obj = {}
	var arr = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_sektors()


	func init_scene() -> void:
		scene.myself = Global.scene.schlachtfeld.instantiate()
		Global.node.game.get_node("Layer2").add_child(scene.myself)


	func init_sektors() -> void:
		arr.sektor = []
		var n = 4
		var m = 6
		var cols = n*2+1
		var rows = m
		scene.myself.columns = cols
		
		for _i in rows:
			arr.sektor.append([])
			
			for _j in cols:
				var input = {}
				input.grid = Vector2(_j,_i)
				input.schlachtfeld = self
				input.owner = "None"
				
				if _j < n:
					input.owner = "Left"
				if _j > n:
					input.owner = "Right"
				
				
				var sektor = Classes_2.Sektor.new(input)
				arr.sektor[_i].append(sektor)


#Фронт
class Vorderseite:
	var obj = {}


	func _init() -> void:
		init_schlachtfeld()


	func init_schlachtfeld() -> void:
		var input = {}
		input.vorderseite = self
		obj.schlachtfeld = Classes_0.Schlachtfeld.new(input)
