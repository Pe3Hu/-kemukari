extends Node



#Династия
class Dynastie:
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		word.house = input_.house
		obj.austausch = input_.austausch


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


	func _init(input_) -> void:
		obj.bieter = input_.bieter


#Дипломат
class Diplomat:
	var obj = {}


	func _init(input_) -> void:
		obj.bieter = input_.bieter


#Участник торгов
class Bieter:
	var word = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.callsign = input_.callsign
		obj.versteigerung = null
		obj.austausch = input_.austausch
		init_schatzamt(input_.gold)
		init_volkswirt()
		init_bewertung()
		init_diplomat()
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.bieter.instantiate()
		scene.myself.set_parent(self)


	func init_schatzamt(gold_) -> void:
		var input = {}
		input.gold = gold_
		input.bieter = self
		obj.schatzamt = Classes_5.Schatzamt.new(input)


	func init_volkswirt() -> void:
		var input = {}
		input.bieter = self
		obj.volkswirt = Classes_5.Volkswirt.new(input)


	func init_bewertung() -> void:
		var input = {}
		input.bieter = self
		obj.bewertung = Classes_5.Bewertung.new(input)


	func init_diplomat() -> void:
		var input = {}
		input.bieter = self
		obj.diplomat = Classes_5.Diplomat.new(input)


#Лот аукциона
class Auktionslos:
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		obj.versteigerung = input_.versteigerung
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.auktionslos.instantiate()
		obj.versteigerung.scene.myself.get_node("Versteigerung").add_child(scene.myself)


#Аукцион
class Versteigerung:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.type = input_.type
		word.house = input_.house
		num.lot = input_.lot
		num.round = {}
		num.round.current = 0
		num.round.max = input_.round
		num.step = input_.step
		num.price = input_.price
		obj.austausch = input_.austausch
		init_scene()
		init_auktionsloss()


	func init_scene() -> void:
		scene.myself = Global.scene.versteigerung.instantiate()
		obj.austausch.scene.myself.get_node("Versteigerungs").add_child(scene.myself)
		scene.myself.set_parent(self)


	func init_auktionsloss() -> void:
		arr.auktionslos = []
		
		for _i in num.lot:
			var input = {}
			input.versteigerung = self
			var auktionslos = Classes_5.Auktionslos.new(input)
			arr.auktionslos.append(auktionslos)


	func payouts() -> void:
		print("payouts ",word.house)
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
		
		for _i in n:
			var input = {}
			input.gold = gold
			input.austausch = self
			arr.callsign.shuffle()
			input.callsign = Global.get_random_element(arr.callsign)
			arr.callsign.erase(input.callsign)
			var bieter = Classes_5.Bieter.new(input)
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
		#England France Spain Japan Turkey China German Russia
		var houses = ["Tudor","Bourbon","Habsburg","Yamato","Osman","Ming","Oldenburg","Romanov"]
		
		for house in houses:
			var input = {}
			input.house = house
			input.austausch = self
			var dynastie = Classes_5.Dynastie.new(input)
			dict.dynastie[house] = dynastie


	func init_versteigerungs() -> void:
		arr.versteigerung = []
		var types = ["min","min","max"]
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
			input.house = Global.get_random_element(houses)
			houses.erase(input.house)
			var versteigerung = Classes_5.Versteigerung.new(input)
			arr.versteigerung.append(versteigerung)


	func next_round() -> void:
		for versteigerung in arr.versteigerung:
			versteigerung.scene.myself.next_round()

