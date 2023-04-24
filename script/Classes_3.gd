extends Node



#Пруд рождения
class Geburtsteich:
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		obj.mutter = input_.mutter
		init_angebot()


	func init_angebot() -> void:
		var input = {}
		input.geburtsteich = self
		obj.angebot = Classes_4.Angebot.new(input)
		obj.angebot.get_new()


#Полководец
class Kriegsherr:
	var obj = {}


	func _init(input_) -> void:
		obj.mutter = input_.mutter


#Казна
class Staatskasse:
	var num = {}
	var obj = {}


	func _init(input_) -> void:
		obj.mutter = input_.mutter
		set_biomass_stock()


	func set_biomass_stock() -> void:
		num.stock = {}
		num.stock.biomass = {}
		num.stock.biomass.max = 1000
		num.stock.biomass.current = num.stock.biomass.max


#Матерь
class Mutter:
	var obj = {}
	var arr = {}


	func _init(input_) -> void:
		obj.planet = input_.planet
		init_staatskasse()
		init_geburtsteich()
		init_kriegsherr()


	func init_staatskasse() -> void:
		var input = {}
		input.mutter = self
		obj.staatskasse = Classes_3.Staatskasse.new(input)


	func init_geburtsteich() -> void:
		var input = {}
		input.mutter = self
		obj.geburtsteich = Classes_3.Geburtsteich.new(input)


	func init_kriegsherr() -> void:
		var input = {}
		input.mutter = self
		obj.kriegsherr = Classes_3.Kriegsherr.new(input)
