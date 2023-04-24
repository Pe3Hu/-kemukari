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


	func _init(input_) -> void:
		obj.vorderseite = input_.vorderseite
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
	var dict = {}
	var obj = {}


	func _init(input_) -> void:
		obj.planet = input_.planet
		set_mutters(input_.mutters)
		init_schlachtfeld()


	func set_mutters(mutters_) -> void:
		dict.mutter = {}
		
		for mutter in mutters_:
			dict.mutter[mutter] = ""
		
		dict.mutter[mutters_.front()] = "Left"
		dict.mutter[mutters_.back()] = "Right"


	func init_schlachtfeld() -> void:
		var input = {}
		input.vorderseite = self
		obj.schlachtfeld = Classes_2.Schlachtfeld.new(input)


#Планета
class Planet:
	var arr = {}
	var obj = {}


	func _init() -> void:
		init_mutters()
		init_vorderseite()


	func init_mutters() -> void:
		arr.mutter = []
		var n = 1
		
		for _i in n:
			var input = {}
			input.planet = self
			var mutter = Classes_3.Mutter.new(input)
			arr.mutter.append(mutter)


	func init_vorderseite() -> void:
		var input = {}
		input.planet = self
		input.mutters = arr.mutter
		obj.vorderseite = Classes_2.Vorderseite.new(input)

