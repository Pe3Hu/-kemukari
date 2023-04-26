extends Node


#Родословная
class Ahnentafel:
	var num = {}
	var obj = {}


	func _init(input_) -> void:
		obj.nachzucht = input_.nachzucht
		num.parameter = Global.dict.ahnentafel.kind[obj.nachzucht.word.kind]


#Потомство
class Nachzucht:
	var num = {}
	var vec = {}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		word.layer = input_.layer
		word.kind = input_.kind
		word.side = null
		obj.mutter = input_.mutter
		obj.vorderseite = input_.vorderseite
		obj.sektor = null
		var input = {}
		input.nachzucht = self
		obj.ahnentafel = Classes_4.Ahnentafel.new(input)
		set_march()


	func set_march() -> void:
		var schlachtfeld = obj.vorderseite.dict.schlachtfeld[word.layer]
		num.march = {}
		num.march.current = 0
		num.march.max = Global.arr.defense_line[schlachtfeld.num.defense_line]
		
		if word.side == null:
			for key in obj.vorderseite.dict.mutter.keys():
				if obj.vorderseite .dict.mutter[key] == obj.mutter:
					word.side = key
		
		if word.side == "Second":
			num.march.max = Global.arr.march.back() - num.march.max


	func set_sektor(sektor_) -> void:
		#var sektor = obj.vorderseite.dict.schlachtfeld[word.layer].get_sektor(vec.grid)
		#print(sektor.parent.vec.grid)
		obj.sektor = sektor_
		sektor_.obj.nachzucht = self
		sektor_.scene.myself.update_status()


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
		num.biomass = 0
		
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
		num.biomass = 0
		arr.geburtsteich = input_.geburtsteich


	func get_new() -> void:
		num.biomass = 0
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
			num.biomass += drillinge.num.biomass
