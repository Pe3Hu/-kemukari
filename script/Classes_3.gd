extends Node



#Родословная
class Ahnentafel:
	var obj = {}


	func _init() -> void:
		pass


#Потомство
class Nachzucht:
	var obj = {}


	func _init() -> void:
		init_schlachtfeld()


	func init_schlachtfeld() -> void:
		var input = {}
		input.vorderseite = self
		obj.schlachtfeld = Classes_0.Schlachtfeld.new(input)


#Матерь
class Mutter:
	var obj = {}


	func _init() -> void:
		init_schlachtfeld()


	func init_schlachtfeld() -> void:
		var input = {}
		input.vorderseite = self
		obj.schlachtfeld = Classes_0.Schlachtfeld.new(input)
