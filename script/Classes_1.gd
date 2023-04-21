extends Node


#пуговица
class Knopf:
	var num = {}
	var word = {}
	var vec = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.type = input_.type
		num.index = Global.num.index.knopf
		Global.num.index.knopf += 1
		vec.position = input_.position
		obj.leinwand = input_.leinwand
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.knopf.instantiate()
		scene.myself.set_offset(vec.position)
		obj.leinwand.scene.myself.get_node("Knopfs").add_child(scene.myself)


#разрез
class Schlitz:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		arr.knopf = input_.knopfs
		arr.klappe = []
		obj.leinwand = input_.leinwand
		obj.leinwand.dict.schlitz[arr.knopf.front()][arr.knopf.back()] = self
		obj.leinwand.dict.schlitz[arr.knopf.back()][arr.knopf.front()] = self


	func init_scene() -> void:
		scene.myself = Global.scene.schlitz.instantiate()
		
		for knopf in arr.knopf:
			scene.myself.add_point(knopf.vec.position)
		
		obj.leinwand.scene.myself.get_node("Schlitzs").add_child(scene.myself)


	func add_klappe(klappe_) -> void:
		if !arr.klappe.has(klappe_):
			arr.klappe.append(klappe_)
		
		if !klappe_.arr.schlitz.has(self):
			klappe_.arr.schlitz.append(self)


	func cut():
		var delta = 1.0/Global.num.delta.max*2
		delta *= Global.get_random_element(Global.arr.delta)
		
		var points = []
		var first = arr.knopf.front()
		var second = arr.knopf.back()
		points.append(first.vec.position)
		points.append(second.vec.position)
		var dot = Global.split_two_point(points, delta)
		
		var input = {}
		input.type = "edge"
		input.leinwand = obj.leinwand
		input.position = Vector2(ceil(dot.x), ceil(dot.y))
		var knopf = Classes_1.Knopf.new(input)
		obj.leinwand.dict.knopf[knopf] = knopf
		
		obj.leinwand.dict.schlitz[first].erase(second)
		obj.leinwand.dict.schlitz[second].erase(first)
		
		obj.leinwand.dict.schlitz[knopf] = {}
		input = {}
		input.leinwand = obj.leinwand
		input.knopfs = [first,knopf]
		var schlitz = Classes_1.Schlitz.new(input)
		input.knopfs = [second,knopf]
		schlitz = Classes_1.Schlitz.new(input)


#лоскут
class Klappe:
	var num = {}
	var arr = {}
	var dict ={}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		num.square = 0
		arr.knopf = input_.knopfs
		arr.schlitz = []
		obj.leinwand = input_.leinwand
		obj.bletz = null
		dict.neighbor = {}
		word.color = "White"
		word.type = input_.type
		init_schlitzs()


	func init_schlitzs() -> void:
		for _i in arr.knopf.size():
			var _j = (_i+1)%arr.knopf.size()
			var knopfs = [arr.knopf[_i],arr.knopf[_j]]
			
			for _k in knopfs.size():
				var _l = (_k+1)%knopfs.size()
				var first = knopfs[_k]
				var second = knopfs[_l]
				
				if !obj.leinwand.dict.schlitz.keys().has(first):
					obj.leinwand.dict.schlitz[first] = {}
				if !obj.leinwand.dict.schlitz.keys().has(second):
					obj.leinwand.dict.schlitz[second] = {}
				
				if !obj.leinwand.dict.schlitz[first].keys().has(second):
					var input = {}
					input.leinwand = obj.leinwand
					input.knopfs = knopfs
					var schlitz = Classes_1.Schlitz.new(input)
				
				obj.leinwand.dict.schlitz[second][first].add_klappe(self)


	func init_polygon() -> void:
		var vertexs = PackedVector2Array()
		
		for knopf in arr.knopf:
			vertexs.append(knopf.vec.position)
		
		var polygon = Polygon2D.new()
		polygon.set_polygon(vertexs)
		
		var h = 0.5
		var s = 0.75
		var v = 1
		
		match word.color:
			"White":
				s = 0.0
				v = 1.0
			"Black":
				v = 0.0
			"Red":
				h = 0.0
			"Green":
				h = 120/360.0
			"Blue":
				h = 210.0/360.0
			"Yellow":
				h = 60.0/360.0
		
		polygon.set_color(Color.from_hsv(h,s,v))
		obj.leinwand.scene.myself.get_node("Klappes").add_child(polygon)


	func calc_square() -> void:
		var a = arr.knopf[0].vec.position
		var b = arr.knopf[1].vec.position
		var c = arr.knopf[2].vec.position
		num.square += abs((b.x-a.x)*(c.y-a.y)-(c.x-a.x)*(b.y-a.y))/2


#подступ
class Zugang:
	var obj = {}
	var arr = {}
	var word = {}
	var scene = {}


	func _init(input_) -> void:
		obj.schlitz = input_.schlitz
		obj.lager = input_.lager
		obj.leinwand = input_.leinwand
		init_knopfs()
		init_scene()


	func init_knopfs() -> void:
		arr.knopf = []
		arr.knopf.append(obj.lager)
		arr.knopf.append_array(obj.schlitz.arr.knopf)
		arr.knopf.append(obj.lager)
		scene.myself = Global.scene.schlitz.instantiate()


	func init_scene() -> void:
		scene.myself = Global.scene.zugang.instantiate()
		
		for knopf in arr.knopf:
			scene.myself.add_point(knopf.vec.position)
		
		obj.leinwand.scene.myself.get_node("Zugangs").add_child(scene.myself)


	func init_polygon() -> void:
		var vertexs = PackedVector2Array()
		
		for knopf in arr.knopf:
			vertexs.append(knopf.vec.position)
		
		var polygon = Polygon2D.new()
		polygon.set_polygon(vertexs)
		
		var h = 0.5
		var s = 0.75
		var v = 1
		word.color = "Black"
		
		match word.color:
			"White":
				s = 0.0
				v = 1.0
			"Black":
				v = 0.0
			"Red":
				h = 0.0
			"Green":
				h = 120/360.0
			"Blue":
				h = 210.0/360.0
			"Yellow":
				h = 60.0/360.0
		
		polygon.set_color(Color.from_hsv(h,s,v))
		obj.leinwand.scene.myself.get_node("Klappes").add_child(polygon)


#заплатка
class Bletz:
	var num = {}
	var arr = {}
	var dict ={}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		num.square = 0
		arr.knopf = []
		arr.klappe = input_.klappes
		obj.leinwand = input_.leinwand
		obj.lager = null
		dict.neighbor = {}
		dict.zugang = {}
		word.color = "White"
		set_knopfs()


	func set_knopfs() -> void:
		for klappe in arr.klappe:
			klappe.obj.bletz = self
			
			for knopf in klappe.arr.knopf:
				if !arr.knopf.has(knopf):
					arr.knopf.append(knopf)


	func connect_klappes() -> void:
		var schlitzs = {}
		
		for klappe in arr.klappe:
			for schlitz in klappe.dict.neighbor.keys():
				if !schlitzs.keys().has(schlitz):
					schlitzs[schlitz] = 1
				else:
					schlitzs[schlitz] += 1
		
		for schlitz in schlitzs.keys():
			if schlitzs[schlitz] == 1:
				for klappe in arr.klappe:
					if klappe.dict.neighbor.keys().has(schlitz):
						var neighbor = klappe.dict.neighbor[schlitz].obj.bletz
						dict.neighbor[schlitz] = neighbor
						neighbor.dict.neighbor[schlitz] = self


	func paint_klappes() -> void:
		for klappe in arr.klappe:
			klappe.word.color = word.color


	func init_polygon() -> void:
		for klappe in arr.klappe:
			klappe.init_polygon()


	func set_lager() -> void:
		var lager_position = Vector2()
		
		var corner = true
		for klappe in arr.klappe:
			corner = klappe.word.type == "corner" && corner
		
		if corner && arr.klappe.size() == 4:
			for knopf in arr.knopf:
				if knopf.word.type == "corner":
					obj.lager = knopf
					break
		else:
			var n = arr.knopf.size()
			var xs = []
			var ys = []
			var corner_positions = []
			var same_axis = false
			
			for knopf in arr.knopf:
				lager_position += knopf.vec.position
				
				match knopf.word.type:
					"corner":
						corner_positions.append(knopf.vec.position)
					"edge":
						if xs.has(knopf.vec.position.x):
							same_axis = true
						else:
							xs.append(knopf.vec.position.x)
						if ys.has(knopf.vec.position.y):
							same_axis = true
						else:
							ys.append(knopf.vec.position.y)
			
			if same_axis && corner_positions.size() == 1:
				lager_position -= corner_positions.front()
				n -= 1
			
			lager_position /= n
			
			var input = {}
			input.type = "lager"
			input.leinwand = obj.leinwand
			input.position = lager_position
			var knopf = Classes_1.Knopf.new(input)
			arr.knopf.append(knopf)
			obj.leinwand.dict.knopf[lager_position] = knopf
			obj.lager = knopf


#полотно
class Leinwand:
	var arr = {}
	var dict = {}
	var scene = {}


	func _init() -> void:
		dict.schlitz = {}
		init_scene()
		init_knopfs()
		init_klappes()
		add_new_schlitzs()
		glue_klappes()
		calc_klappe_squares()
		set_lagers()
		init_zugangs()


	func init_scene() -> void:
		scene.myself = Global.scene.leinwand.instantiate()
		scene.myself.visible = false
		Global.node.game.get_node("Layer1").add_child(scene.myself)


	func init_knopfs() -> void:
		dict.knopf = {}
		
		for _i in Global.num.leinwand.rows:
			for _j in Global.num.leinwand.cols:
				var input = {}
				input.type = "corner"
				input.leinwand = self
				input.position = Vector2(_i,_j)*Global.num.leinwand.a
				var knopf = Classes_1.Knopf.new(input)
				dict.knopf[input.position] = knopf


	func init_klappes() -> void:
		var border = Vector2(Global.num.leinwand.rows-1,Global.num.leinwand.cols-1)*Global.num.leinwand.a
		arr.klappe = []
		
		for key in dict.knopf.keys():
			if key.x < border.x && key.y < border.y:
				var input = {}
				input.leinwand = self
				input.type = "square"
				input.knopfs = []
				
				for neighbor in Global.dict.neighbor.zero:
					var position = key+neighbor*Global.num.leinwand.a
					input.knopfs.append(dict.knopf[position])
				
				var klappe = Classes_1.Klappe.new(input)
				klappe.init_schlitzs()
				arr.klappe.append(klappe)
		
		set_klappe_neighbors()


	func set_klappe_neighbors() -> void:
		for first_knopf in dict.schlitz.keys():
			for second_knopf in dict.schlitz[first_knopf].keys():
				var schlitz = dict.schlitz[first_knopf][second_knopf]
				
				if schlitz.arr.klappe.size() > 1:
					var first_klappe = schlitz.arr.klappe.front()
					var second_klappe = schlitz.arr.klappe.back()
					first_klappe.dict.neighbor[schlitz] = second_klappe
					second_klappe.dict.neighbor[schlitz] = first_klappe


	func add_new_schlitzs() -> void:
		var schlitzs = []
		
		for first in dict.schlitz.keys():
			for second in dict.schlitz[first].keys():
				var schlitz = dict.schlitz[first][second]
				
				if !schlitzs.has(schlitz):
					schlitzs.append(schlitz)
		
		for schlitz in schlitzs:
			schlitz.cut()
		
		rework_klappes()


	func rework_klappes() -> void:
		arr.klappe = []
		var edges = []
		var centers = {}
		
		for key in dict.knopf.keys():
			var knopf = dict.knopf[key]
			
			match knopf.word.type:
				"corner":
					for _i in dict.schlitz[knopf].keys().size():
						var first = dict.schlitz[knopf].keys()[_i]
						
						for _j in range(_i,dict.schlitz[knopf].keys().size()):
							var second = dict.schlitz[knopf].keys()[_j]
							
							if first.vec.position.x != second.vec.position.x && first.vec.position.y != second.vec.position.y:
								var input = {}
								input.leinwand = self
								input.knopfs = [knopf,first,second]
								input.type = "corner"
								var klappe = Classes_1.Klappe.new(input)
								arr.klappe.append(klappe)
				"edge":
					edges.append(knopf)
		
		for _i in Global.num.leinwand.rows-1:
			for _j in Global.num.leinwand.cols-1:
				var center = Vector2(_i+0.5,_j+0.5)*Global.num.leinwand.a
				centers[center] = []
				
				for edge in edges:
					var d = abs(edge.vec.position.x-center.x)+abs(edge.vec.position.y-center.y)
					
					if d < Global.num.leinwand.a:
						centers[center].append(edge)
		
		for key in centers.keys():
			var trios = [[],[]]
			trios[0].append_array(centers[key])
			trios[1].append_array(centers[key])
			var first = Global.get_random_element(trios[0])
			trios[0].erase(first)
			var second = null
			
			for knopf in trios[0]:
				var x = abs(knopf.vec.position.x-first.vec.position.x)
				var y = abs(knopf.vec.position.y-first.vec.position.y)
				
				if x == Global.num.leinwand.a || y == Global.num.leinwand.a:
					second = knopf
					break
			
			trios[1].erase(second)
			
			for trio in trios:
				var input = {}
				input.leinwand = self
				input.knopfs = trio
				input.type = "center"
				var klappe = Classes_1.Klappe.new(input)
				arr.klappe.append(klappe)
		
		set_klappe_neighbors()


	func glue_klappes() -> void:
		arr.bletz = []
		var unglueds = []
		var glueds = []
		unglueds.append_array(arr.klappe)
		
		while unglueds.size() > 0:
			var klappes = []
			var current_klappe = Global.get_random_element(unglueds)
			var options = []
			
			for size in Global.dict.klappe.size.keys():
				for types in Global.dict.klappe.size[size]:
					if types.has(current_klappe.word.type):
						for _i in Global.dict.klappe.duplicate[size]:
							options.append(types)
			
			var types = []
			var origin_types = []
			types.append_array(Global.get_random_element(options))
			origin_types.append_array(types)
			klappes.append(current_klappe)
			unglueds.erase(current_klappe)
			types.erase(current_klappe.word.type)
			
			while types.size() > 0:
				var neighbors = []
				
				for klappe in klappes:
					for schlitz in klappe.dict.neighbor.keys():
						var neighbor = klappe.dict.neighbor[schlitz]
						
						if unglueds.has(neighbor) && types.has(neighbor.word.type):
							neighbors.append(neighbor)
				
				if neighbors.size() == 0:
					types = []
				else:
					current_klappe = Global.get_random_element(neighbors)
					klappes.append(current_klappe)
					unglueds.erase(current_klappe)
					types.erase(current_klappe.word.type)
			
			if origin_types == ["corner", "corner", "corner", "corner"] && klappes.size() != origin_types.size():
				unglueds.append_array(klappes)
			else:
				glueds.append(klappes)
		
		for glued in glueds:
			var input = {}
			input.klappes = glued
			input.leinwand = self
			var bletz = Classes_1.Bletz.new(input)
			arr.bletz.append(bletz)
		
		for bletz in arr.bletz:
			bletz.connect_klappes()
		
		set_bletz_colors()


	func set_bletz_colors() -> void:
		var origin = arr.bletz[0]
		var unpainted = [origin]
		
		while unpainted.size() > 0:
			var bletz = unpainted.pop_front()
			var colors = []
			colors.append_array(Global.arr.color)
			
			for schlitz in bletz.dict.neighbor.keys():
				var neighbor = bletz.dict.neighbor[schlitz]
				colors.erase(neighbor.word.color)
				
				if neighbor.word.color == "White" && !unpainted.has(neighbor):
					unpainted.append(neighbor)
			
			bletz.word.color = Global.get_random_element(colors)
			bletz.paint_klappes()
		
		for bletz in arr.bletz:
			bletz.init_polygon()


	func calc_klappe_squares() -> void:
		var s = Global.num.leinwand.a*Global.num.leinwand.a/4
		
		for klappe in arr.klappe:
			klappe.calc_square()
			klappe.obj.bletz.num.square += klappe.num.square
		
		var n = 6
		
		var counts = {}
		
		for _i in range(2,n*3):
			counts[_i] = 0
		
		for bletz in arr.bletz:
			var size = bletz.num.square/s*n
			
			for key in counts.keys():
				if size < key:
					counts[key] += 1
					break
		
		#print("calc_klappe_squares: ",counts)


	func set_lagers() -> void:
		for bletz in arr.bletz:
			bletz.set_lager()


	func init_zugangs() -> void:
		for bletz in arr.bletz:
			var schlitzs = []
			
			for klappe in bletz.arr.klappe:
				for schlitz in klappe.arr.schlitz:
					if schlitz.arr.knopf.front().word.type != schlitz.arr.knopf.back().word.type:
						if !schlitzs.has(schlitz):
							schlitzs.append(schlitz)
						else:
							schlitzs.erase(schlitz)
			
			for schlitz in bletz.dict.neighbor.keys():
				if !schlitzs.has(schlitz):
					schlitzs.append(schlitz)
			
			for schlitz in schlitzs:
				var input = {}
				input.schlitz = schlitz
				input.lager = bletz.obj.lager
				input.leinwand = self
				var zugang = Classes_1.Zugang.new(input)
				bletz.dict.zugang[schlitz] = zugang
