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
		#init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.sektor.instantiate()
		obj.schlachtfeld.scene.myself.add_child(scene.myself)
		scene.myself.set_status(self)


#Поле боя
class Schlachtfeld:
	var num = {}
	var word = {}
	var obj = {}
	var arr = {}
	var scene = {}


	func _init(input_) -> void:
		num.size = input_.size
		word.layer = input_.layer
		obj.vorderseite = input_.vorderseite
		init_scene()
		init_sektors()


	func init_scene() -> void:
		scene.myself = Global.scene.schlachtfeld.instantiate()
		Global.node.game.get_node("Layer2").add_child(scene.myself)


	func init_sektors() -> void:
		arr.sektor = []
		var n = 4
		var cols = n*2+1
		var rows = num.size
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
		init_schlachtfelds()


	func set_mutters(mutters_) -> void:
		dict.mutter = {}
		
		for mutter in mutters_:
			mutter.dict.vorderseite[self] = false
		
		dict.mutter["Left"] = mutters_.front()
		
		if mutters_.front() != mutters_.back():
			dict.mutter["Right"] = mutters_.back()


	func init_schlachtfelds() -> void:
		dict.schlachtfeld = {}
		var sizes = [5,7,5]
		
		for _i in sizes.size():
			var input = {}
			input.vorderseite = self
			input.size = sizes[_i]
			input.layer = ""
			
			match _i:
				0:
					input.layer = "Top"
				1:
					input.layer = "Mid"
				2:
					input.layer = "Bot"
			
			var schlachtfeld = Classes_2.Schlachtfeld.new(input)
			dict.schlachtfeld[input.layer] = schlachtfeld


	func battle_preparation() -> void:
		for side in dict.mutter.keys():
			dict.mutter[side].battle_preparation(self)


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

