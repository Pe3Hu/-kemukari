extends Node


#Сектор
class Sektor:
	var word = {}
	var vec = {}
	var dict = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.owner = input_.owner
		vec.grid = input_.grid
		obj.schlachtfeld = input_.schlachtfeld
		obj.nachzucht = null
		dict.neighbor = {}
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.sektor.instantiate()
		obj.schlachtfeld.scene.myself.add_child(scene.myself)
		scene.myself.set_parent(self)
		scene.myself.update_status()


#Поле боя
class Schlachtfeld:
	var num = {}
	var word = {}
	var obj = {}
	var arr = {}
	var dict = {}
	var scene = {}


	func _init(input_) -> void:
		num.size = input_.size
		num.defense_line = input_.defense_line
		word.layer = input_.layer
		obj.vorderseite = input_.vorderseite
		init_sides()
		init_scene()
		init_sektors()


	func init_scene() -> void:
		scene.myself = Global.scene.schlachtfeld.instantiate()
		obj.vorderseite.scene.myself.get_node("Layers").add_child(scene.myself)


	func init_sides() -> void:
		dict.bench = {}
		dict.combatant = {}
		
		for side in Global.arr.side:
			dict.bench[side] = []
			dict.combatant[side] = []


	func init_sektors() -> void:
		arr.sektor = []
		var n = 3
		num.rows = n*2+1
		num.cols = num.size
		scene.myself.columns = num.cols
		
		for _i in num.rows:
			arr.sektor.append([])
			
			for _j in num.cols:
				var input = {}
				input.grid = Vector2(_j,_i)
				input.schlachtfeld = self
				input.owner = "None"
				
				if _i < n:
					input.owner = "Frist"
				if _i > n:
					input.owner = "Second"
				
				var sektor = Classes_2.Sektor.new(input)
				arr.sektor[_i].append(sektor)
		
		set_neighbors()


	func set_neighbors() -> void:
		for sektors in arr.sektor:
			for sektor in sektors:
				for direction in Global.dict.neighbor.linear2:
					var grid = direction+sektor.vec.grid
					var neighbor = get_sektor(grid)
					
					if neighbor != null:
						sektor.dict.neighbor[direction] = neighbor


	func find_free_spot(side_):
		var anchor = Vector2(num.cols/2,num.rows/2)
		var side_shift = Vector2()
		
		match side_:
			"First":
				side_shift.y += 1
			"Second":
				side_shift.y -= 1
		
		anchor += side_shift
		var useds = []
		var unuseds = []
		var sektor = get_sektor(anchor)
		var counter = 0
		var stopper = num.cols*num.rows/2
		
		while sektor.obj.nachzucht != null && counter < stopper:
			counter += 1
			useds.append(sektor)
			
			for direction in sektor.dict.neighbor.keys():
				if direction.y == 0:
					var neighbor = get_sektor(sektor.vec.grid+direction)
					
					if !useds.has(neighbor):
						unuseds.append(neighbor)
			
			#print(unuseds.size())
			if unuseds.size() > 0:
				sektor = Global.get_random_element(unuseds)
				unuseds.erase(sektor)
			else:
				anchor += side_shift
				useds = []
				unuseds = []
				sektor = get_sektor(anchor)
				
				if sektor == null:
					print("find_free_spot error")
					return get_sektor(Vector2(num.cols/2,num.rows/2))
		
		if word.layer == "Bot":
			print(sektor.vec.grid)
		return sektor


	func get_sektor(grid_):
		#var index = grid_.y*num.cols+grid_.y
		#return scene.myself.get_children()[index]
		var sektor = null
		
		if check_grid(grid_):
			sektor = arr.sektor[grid_.y][grid_.x]
		return sektor


	func check_grid(grid_) -> bool:
		return grid_.y >= 0 && grid_.y < num.rows && grid_.x >= 0 && grid_.x < num.cols


	func hide() -> void:
		scene.myself.visible = false


#Фронт
class Vorderseite:
	var word = {}
	var arr = {}
	var dict = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.selected = {}
		word.selected.schlachtfeld = "Bot"
		obj.planet = input_.planet
		arr.march = []
		init_scene()
		set_mutters(input_.mutters)
		init_schlachtfelds()


	func init_scene() -> void:
		scene.myself = Global.scene.vorderseite.instantiate()
		Global.node.game.get_node("Layer2").add_child(scene.myself)


	func set_mutters(mutters_) -> void:
		dict.mutter = {}
		
		for mutter in mutters_:
			mutter.dict.vorderseite[self] = false
		
		dict.mutter["First"] = mutters_.front()
		
		if mutters_.front() != mutters_.back():
			dict.mutter["Second"] = mutters_.back()


	func init_schlachtfelds() -> void:
		dict.schlachtfeld = {}
		var sizes = [5,7,5]
		var half = Global.arr.defense_line.size()/2
		
		for _i in sizes.size():
			var input = {}
			input.vorderseite = self
			input.size = sizes[_i]
			input.layer = Global.arr.layer[_i]
			input.defense_line = half
			var schlachtfeld = Classes_2.Schlachtfeld.new(input)
			dict.schlachtfeld[input.layer] = schlachtfeld


	func battle_preparation() -> void:
		for side in dict.mutter.keys():
			dict.mutter[side].battle_preparation(self)


	func next_turn() -> void:
		replenishment_movement_phase()
		combatant_arrangement_phase()


	func replenishment_movement_phase() -> void:
		for _i in range(arr.march.size()-1,-1,-1):
			var nachzucht = arr.march[_i]
			nachzucht.num.march.current += nachzucht.obj.ahnentafel.num.parameter["Mobility"]
			
			if nachzucht.num.march.current >= nachzucht.num.march.max:
				arr.march.erase(nachzucht)
				var schlachtfeld = dict.schlachtfeld[nachzucht.word.layer]
				schlachtfeld.dict.bench[nachzucht.word.side].append(nachzucht)


	func combatant_arrangement_phase() -> void:
		for layer in dict.schlachtfeld.keys():
			var schlachtfeld = dict.schlachtfeld[layer]
			
			for side in Global.arr.side:
				if schlachtfeld.dict.bench[side].size() > 0:
					dict.mutter[side].obj.kriegsherr.combatant_arrangement(schlachtfeld, side)


	func select_next_schlachtfeld(shit_) -> void:
		var index = Global.arr.layer.find(word.selected.schlachtfeld)
		index = (index+shit_+Global.arr.layer.size())%Global.arr.layer.size()
		word.selected.schlachtfeld = Global.arr.layer[index]
		
		for layer in dict.schlachtfeld.keys():
			if layer != word.selected.schlachtfeld:
				dict.schlachtfeld[layer].hide()


#Планета
class Planet:
	var num = {}
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
