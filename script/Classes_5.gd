extends Node


#Династия
class Dynastie:
	var num = {}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		word.house = input_.house
		obj.austausch = input_.austausch
		num.parameter = Global.dict.dynastie.house[word.house]


	func get_parameters_for_lots(size_) -> Array:
		var parameters = []
		var options = []
		
		for key in num.parameter.keys():
			for _j in num.parameter[key]:
				options.append(key)
		
		for _i in size_:
			options.shuffle()
			var parameter = Global.get_random_element(options)
			parameters.append(parameter)
		
		return parameters


#Сокровище
class Kostbarkeiten:
	var num = {}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		word.type = input_.type
		num.stack = input_.stack



#Лот аукциона
class Auktionslos:
	var word = {}
	var num = {}
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		obj.versteigerung = input_.versteigerung
		word.type = input_.type
		num.stack = input_.stack
		arr.bieter = []
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.auktionslos.instantiate()
		obj.versteigerung.scene.myself.get_node("Versteigerung").add_child(scene.myself)
		scene.myself.set_parent(self)


#Аукцион
class Versteigerung:
	var num = {}
	var word = {}
	var arr = {}
	var dict = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.type = input_.type
		obj.dynastie = input_.dynastie
		num.lot = input_.lot
		num.round = {}
		num.round.current = 0
		num.round.max = input_.round
		num.step = input_.step
		num.price = input_.price
		obj.austausch = input_.austausch
		arr.bieter = []
		init_scene()
		init_auktionsloss()


	func init_scene() -> void:
		scene.myself = Global.scene.versteigerung.instantiate()
		obj.austausch.scene.myself.get_node("Versteigerungs").add_child(scene.myself)
		scene.myself.set_parent(self)


	func init_auktionsloss() -> void:
		var min_stack = 50
		var max_stack = 150
		arr.auktionslos = []
		var types = []
		var parameters = obj.dynastie.get_parameters_for_lots(num.lot)
		
		for _i in num.lot:
			var input = {}
			input.versteigerung = self
			#var parameter = Global.get_random_element(Global.dict.volkswirt.parameter)
			input.type = parameters[_i]+" dust"
			Global.rng.randomize()
			input.stack = round(Global.rng.randf_range(min_stack, max_stack))
			var auktionslos = Classes_5.Auktionslos.new(input)
			arr.auktionslos.append(auktionslos)
		
		set_impersonal_assessment()


	func set_impersonal_assessment() -> void:
		dict.impersonal_assessment = {}
		
		for auktionslos in arr.auktionslos:
			var parameter = auktionslos.word.type.split(" ")[0]
			var dynastie = auktionslos.obj.versteigerung.obj.dynastie
			var weight = auktionslos.num.stack
			
			dict.impersonal_assessment[auktionslos] = dynastie.num.parameter[parameter]*weight
		
		if word.type == "min":
			dict.impersonal_assessment = Global.reverse_weights(dict.impersonal_assessment)
		
		dict.impersonal_assessment = Global.from_weight_to_percentage(dict.impersonal_assessment)


	func payouts() -> void:
		print("payouts ",obj.dynastie.word.house)
		obj.austausch.scene.myself.get_node("Versteigerungs").remove_child(scene.myself)


#Биржа
class Austausch:
	var arr = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_bieters()
		init_dynasties()
		init_versteigerungs()


	func init_scene() -> void:
		scene.myself = Global.scene.austausch.instantiate()
		Global.node.game.get_node("Layer5").add_child(scene.myself)


	func init_bieters() -> void:
		arr.callsign = []
		var n = 10
		var m = 26
		
		for _i in n:
			for _j in n:
				for _k in m:
					var callsign = str(_i)+String.chr(65+_k)+str(_j)
					arr.callsign.append(callsign)
		
		arr.bieter = []
		
		var gold = 1000
		n = 1000
		
		for _i in n:
			var input = {}
			input.gold = gold
			input.austausch = self
			arr.callsign.shuffle()
			input.callsign = Global.get_random_element(arr.callsign)
			arr.callsign.erase(input.callsign)
			var bieter = Classes_6.Bieter.new(input)
			arr.bieter.append(bieter)
		
		sort_bieters()


	func sort_bieters() -> void:
		arr.bieter.sort_custom(func(a, b): return a.obj.schatzamt.num.aether.total > b.obj.schatzamt.num.aether.total)
		var node = scene.myself.get_node("Bieters")
		
		var top = 10
		
		for children in node.get_children():
			node.remove_child(children)
		
		for _i in top:
			var bieter = arr.bieter[_i]
			node.add_child(bieter.scene.myself)


	func init_dynasties() -> void:
		dict.dynastie = {}
		#var owners = ["Alexander","Caesar","Temujin","Elizabeth","Karl"]
		#England France Spain Japan Turkey China Russia German
		var houses = ["Tudor","Bourbon","Habsburg","Yamato","Osman","Ming","Romanov"]#"Oldenburg"
		
		for house in houses:
			var input = {}
			input.house = house
			input.austausch = self
			var dynastie = Classes_5.Dynastie.new(input)
			dict.dynastie[house] = dynastie


	func init_versteigerungs() -> void:
		arr.versteigerung = []
		var types = ["min","min","min"]
		var lots = [3,3,3]
		var rounds = [2,3,2]
		var steps = [1,2,3]
		var prices = [10,10,10]
		var houses = dict.dynastie.keys()
		
		for _i in types.size():
			var input = {}
			input.type = types[_i]
			input.lot = lots[_i]
			input.round = rounds[_i]
			input.step = steps[_i]
			input.price = prices[_i]
			input.austausch = self
			houses.shuffle()
			var house = Global.get_random_element(houses)
			houses.erase(house)
			input.dynastie = dict.dynastie[house]
			var versteigerung = Classes_5.Versteigerung.new(input)
			arr.versteigerung.append(versteigerung)
		
		fill_versteigerungs()


	func fill_versteigerungs() -> void:
		for bieter in arr.bieter:
			bieter.obj.volkswirt.select_versteigerung()
		
		for versteigerung in arr.versteigerung:
			versteigerung.scene.myself.update_members()


	func next_round() -> void:
		for versteigerung in arr.versteigerung:
			versteigerung.scene.myself.next_round()

