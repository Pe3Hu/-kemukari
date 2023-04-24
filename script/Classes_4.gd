extends Node


#Родословная
class Ahnentafel:
	var obj = {}


	func _init() -> void:
		pass


#Потомство
class Nachzucht:
	var obj = {}


	func _init(input_) -> void:
		obj.mutter = input_.mutter


#Тройняшки
class Drillinge:
	var num = {}
	var arr = {}


	func _init(input_) -> void:
		arr.kind = input_.kinds
		arr.tag = []
		set_nums()


	func set_nums() -> void:
		num.index = Global.num.index.drillinge
		Global.num.index.drillinge += 1
		num.offense = 0
		num.retention = 0
		num.mobility = 0
		num.price = 0
		
		for kind in arr.kind:
			var ahnentafel = Global.dict.ahnentafel.kind[kind]
			
			for key in num.keys():
				if ahnentafel.keys().has(key.capitalize()):
					num[key] += ahnentafel[key.capitalize()]


#Предложение
class Angebot:
	var num = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		num.size = 3
		arr.geburtsteich = input_.geburtsteich


	func get_new() -> void:
		arr.drillinge = []
		arr.tag = ["Hodgepodge"]
		
		for _i in num.size-1:
			var tag = null
			
			while tag == null || arr.tag.has(tag):
				tag = Global.get_random_element(Global.dict.drillinge.tag)
			
			arr.tag.append(tag)
		
		for tag in arr.tag:
			var drillinges = []
			
			for drillinge in Global.dict.drillinge.all:
				if drillinge.arr.tag.has(tag):
					drillinges.append(drillinge)
				if tag == "Hodgepodge" && drillinge.arr.tag.size() == 0:
					drillinges.append(drillinge)
			
			var drillinge = null
			
			while drillinge == null || arr.drillinge.has(drillinge):
				drillinge = Global.get_random_element(drillinges)
			
			arr.drillinge.append(drillinge)
		
		for _i in arr.tag.size():
			print(arr.tag[_i], arr.drillinge[_i].arr.kind)
