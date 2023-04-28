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
	var obj = {}


	func _init(input_) -> void:
		obj.versteigerung = null
		obj.austausch = input_.austausch
		init_schatzamt(input_.gold)
		init_volkswirt()
		init_bewertung()
		init_diplomat()


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


	func _init(input_) -> void:
		obj.versteigerung = input_.versteigerung


#Аукцион
class Versteigerung:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		word.type = input_.type
		num.lot = input_.lot
		num.step = input_.step
		num.price = input_.price
		obj.austausch = input_.austausch
		init_auktionsloss()


	func init_auktionsloss() -> void:
		arr.auktionslos = []
		
		for _i in num.lot:
			var input = {}
			input.versteigerung = self
			var auktionslos = Classes_5.Auktionslos.new(input)
			arr.auktionslos.append(auktionslos)


#Династия
class Dynastie:
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		word.house = input_.house
		obj.austausch = input_.austausch


#Биржа
class Austausch:
	var arr = {}
	var obj = {}
	var dict = {}


	func _init() -> void:
		init_bieters()
		init_dynasties()
		init_versteigerungs()


	func init_bieters() -> void:
		arr.bieter = []
		var n = 100
		var gold = 1000
		
		for _i in n:
			var input = {}
			input.gold = gold
			input.austausch = self
			var bieter = Classes_5.Bieter.new(input)
			arr.bieter.append(bieter)


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
			dict.dynastie[dynastie] = 0


	func init_versteigerungs() -> void:
		arr.versteigerung = []
		var types = ["min","min","max"]
		var lots = [3,3,3]
		var stages = [2,3,2]
		var steps = [1,2,3]
		var prices = [10,10,10]
		
		for _i in types.size():
			var input = {}
			input.type = types[_i]
			input.lot = lots[_i]
			input.step = steps[_i]
			input.price = prices[_i]
			input.austausch = self
			var versteigerung = Classes_5.Versteigerung.new(input)
			arr.versteigerung.append(versteigerung)


