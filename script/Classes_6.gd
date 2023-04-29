extends Node


#Ставка
class Bewertung:
	var num = {}
	var obj = {}


	func _init(input_) -> void:
		obj.bieter = input_.bieter


#Сокровищница
class Schatzamt:
	var num = {}
	var obj = {}


	func _init(input_) -> void:
		obj.bieter = input_.bieter
		init_gold(input_.gold)
		init_aether()


	func init_gold(gold_) -> void:
		num.gold = {}
		num.gold.max = gold_
		num.gold.current = num.gold.max


	func init_aether() -> void:
		num.aether = {}
		num.aether.stage = -1
		num.aether.harvesting = 1
		next_aether_phase()


	func next_aether_phase() -> void:
		num.aether.stage += 1
		num.aether.current = 0
		num.aether.max = pow((num.aether.stage+10),2)
		num.aether.total = num.aether.current


#Экономист
class Volkswirt:
	var obj = {}
	var dict = {}


	func _init(input_) -> void:
		obj.bieter = input_.bieter
		init_sins()
		prioritize()
		init_common_sense()


	func init_sins() -> void:
		var deviations = []
		var total_deviation = 2.0
		Global.rng.randomize()
		var deviation = Global.rng.randf_range(0, total_deviation)
		deviations.append(deviation)
		deviations.append(total_deviation-deviation)
		
		dict.sin = {}
		var n = 2
		var sins = Global.dict.volkswirt.sin.keys()
		
		for _i in n:
			var sin = Global.get_random_element(sins)
			sins.erase(sin)
			dict.sin[sin] = 0.5+deviations[_i]


	func prioritize() -> void:
		dict.priority = {}
		var base = 10
		
		for parameter in Global.dict.volkswirt.parameter:
			dict.priority[parameter] = base
			var scale = 1
		
			for sin in dict.sin.keys():
				if Global.dict.volkswirt.sin[sin].keys().has(parameter):
					dict.priority[parameter] += Global.dict.volkswirt.sin[sin][parameter]*dict.sin[sin]
			
			dict.priority[parameter] = round(dict.priority[parameter])


	func init_common_sense() -> void:
		var base = 3
		var deviations = []
		var total_deviation = 4
		Global.rng.randomize()
		var deviation = Global.rng.randi_range(0, total_deviation)
		deviations.append(deviation)
		deviations.append(total_deviation-deviation)
		dict.common_sense = {}
		
		for _i in Global.arr.opinion.size():
			var opinion = Global.arr.opinion[_i]
			dict.common_sense[opinion] = base+deviations[_i]
		
		#print(dict.common_sense)


	func select_versteigerung() -> void:
#		var options = []
#
#		for versteigerung in obj.bieter.obj.austausch.arr.versteigerung:
#			for parameter in dict.priority.keys():
#				var amount = dict.priority[parameter]*versteigerung.obj.dynastie.num.parameter[parameter]
#
#				for _i in amount:
#					options.append(versteigerung)
#
#		options.shuffle()
#		obj.bieter.obj.versteigerung = Global.get_random_element(options)
		
		var dict_ = {}
		
		for versteigerung in obj.bieter.obj.austausch.arr.versteigerung:
			for parameter in dict.priority.keys():
				dict_[versteigerung] = dict.priority[parameter]*versteigerung.obj.dynastie.num.parameter[parameter]
		
		obj.bieter.obj.versteigerung = Global.get_random_key(dict_)
		obj.bieter.obj.versteigerung.arr.bieter.append(obj.bieter)


	func select_auktionslos() -> void:
		if obj.bieter.obj.auktionslos == null:
			var assessment = {}
			assessment.personal = get_personal_assessment()
			assessment.impersonal = obj.bieter.obj.versteigerung.dict.impersonal_assessment
			var weights = {}
			
			for auktionslos in obj.bieter.obj.versteigerung.arr.auktionslos:
				weights[auktionslos] = 0
				
				for opinion in dict.common_sense.keys():
					weights[auktionslos] += dict.common_sense[opinion]*assessment[opinion][auktionslos]
			
			obj.bieter.obj.auktionslos = Global.get_random_key(weights)
			obj.bieter.obj.auktionslos.arr.bieter.append(obj.bieter)


	func get_personal_assessment() -> Dictionary:
		var personal_assessment = {}
		
		for auktionslos in obj.bieter.obj.versteigerung.arr.auktionslos:
			var parameter = auktionslos.word.type.split(" ")[0]
			personal_assessment[auktionslos] = dict.priority[parameter]
		
		personal_assessment = Global.from_weight_to_percentage(personal_assessment)
		return personal_assessment


#Воитель
class Krieger:
	var num = {}
	var obj = {}


	func _init(input_) -> void:
		obj.bieter = input_.bieter
		set_nums()


	func set_nums() -> void:
		num.attack = {}
		num.attack.base = 1
		num.attack.increase = {}
		num.attack.increase.first = 0
		num.attack.increase.second = 0
		num.attack.scale = 1.0
		num.defense = {}
		num.defense.base = 1
		num.defense.increase = {}
		num.defense.increase.first = 0
		num.defense.increase.second = 0
		num.defense.scale = 1.0


	func get_num(parametr_) -> int:
		var value = float(num[parametr_].base+num[parametr_].increase.first)
		value *= num[parametr_].scale
		value += num[parametr_].increase.second
		return floor(value)


#Участник торгов
class Bieter:
	var word = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.callsign = input_.callsign
		obj.versteigerung = null
		obj.auktionslos = null
		obj.austausch = input_.austausch
		init_schatzamt(input_.gold)
		init_volkswirt()
		init_bewertung()
		init_krieger()
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.bieter.instantiate()
		scene.myself.set_parent(self)


	func init_schatzamt(gold_) -> void:
		var input = {}
		input.gold = gold_
		input.bieter = self
		obj.schatzamt = Classes_6.Schatzamt.new(input)


	func init_volkswirt() -> void:
		var input = {}
		input.bieter = self
		obj.volkswirt = Classes_6.Volkswirt.new(input)


	func init_bewertung() -> void:
		var input = {}
		input.bieter = self
		obj.bewertung = Classes_6.Bewertung.new(input)


	func init_krieger() -> void:
		var input = {}
		input.bieter = self
		obj.krieger = Classes_6.Krieger.new(input)
