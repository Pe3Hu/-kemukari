extends Node


var rng = RandomNumberGenerator.new()
var num = {}
var dict = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}
var vec = {}
var scene = {}


func init_num() -> void:
	num.index = {}
	num.index.knopf = 0
	num.index.drillinge = 0
	
	num.leinwand = {}
	num.leinwand.n = 6
	num.leinwand.rows = num.leinwand.n
	num.leinwand.cols = num.leinwand.n
	num.leinwand.a = 144
	
	num.delta = {}
	num.delta.max = 12
	
	num.saal = {}
	num.saal.height = 10
	num.saal.width = 3
	num.saal.depth = 7
	
	num.pielautomat = {}
	num.pielautomat.height = 3
	num.pielautomat.width = 5


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	
	dict.klappe = {}
	dict.klappe.size = {
		1: [["corner"], ["center"]],
		2: [["corner", "corner"], ["corner", "center"], ["center", "center"]],
		3: [["corner", "corner", "center"], ["corner", "center", "center"]],
		4: [["corner", "corner", "corner", "corner"]]
	}
	dict.klappe.duplicate = {
		1: 8,
		2: 4,
		3: 2,
		4: 1
	}
	
	init_ahnentafel()
	init_nachzucht()
	set_drillinge()


func init_ahnentafel() -> void:
	dict.ahnentafel = {}
	var path = "res://asset/json/ahnentafel_data.json"
	var array = load_data(path)
	dict.ahnentafel.kind = {}
	
	for ahnentafel in array:
		var data = {}

		for key in ahnentafel.keys():
			if key != "Kind":
				data[key] = ahnentafel[key]
		
		dict.ahnentafel.kind[ahnentafel["Kind"]] = data


func init_nachzucht() -> void:
	dict.nachzucht = {}
	var path = "res://asset/json/nachzucht_data.json"
	var array = load_data(path)
	dict.nachzucht.parameter = {}
	
	for nachzucht in array:
		var data = {}

		for key in nachzucht.keys():
			if key != "Parameter":
				data[key] = nachzucht[key]
		
		dict.nachzucht.parameter[nachzucht["Parameter"]] = data


func set_drillinge() -> void:
	dict.drillinge = {}
	dict.drillinge.tag = ["Offense","Retention","Mobility","Twin","Frontline","Backline","Cheap","Expensive"]
	dict.drillinge.all = []
	
	for _i in dict.ahnentafel.kind.keys().size():
		for _j in dict.ahnentafel.kind.keys().size():
			for _l in dict.ahnentafel.kind.keys().size():
				var input = {}
				input.kinds = []
				input.kinds.append(dict.ahnentafel.kind.keys()[_i])
				input.kinds.append(dict.ahnentafel.kind.keys()[_j])
				input.kinds.append(dict.ahnentafel.kind.keys()[_l])
				var drillinge = Classes_4.Drillinge.new(input)
				dict.drillinge.all.append(drillinge)
	
	var datas = []
	var ratings = []
	
	for key in dict.drillinge.all.front().num.keys():
		if key != "index":
			ratings.append(key)
	
	for drillinge in dict.drillinge.all:
		var data = {}
		data.drillinge = drillinge
		data.rating = {}
		
		for key in ratings:
			data.rating[key] = -1
		
		datas.append(data)
	
	
	for rating in ratings:
		datas.sort_custom(func(a, b): return a.drillinge.num[rating] > b.drillinge.num[rating])
		
		for _i in datas.size():
			datas[_i].rating[rating] = _i
	
	var best_percent = 30
	var winner_amount = datas.size()*best_percent/100
	
	for data in datas:
		for tag in dict.drillinge.tag:
			var key = tag.to_lower()
			var flag = false
			
			match tag:
				"Offense":
					flag = data.rating[key] < winner_amount
				"Retention":
					flag = data.rating[key] < winner_amount
				"Mobility":
					flag = data.rating[key] < winner_amount
				"Expensive":
					key = "biomass"
					
					flag = data.rating[key] < winner_amount/2
				"Cheap":
					key = "biomass"
					
					flag = data.rating[key] >= datas.size()-winner_amount/2
				"Twin":
					flag = true
					
					for kind in data.drillinge.arr.kind:
						flag = flag && (kind == data.drillinge.arr.kind.front())
				"Frontline":
					flag = true
					
					for kind in data.drillinge.arr.kind:
						var throwability = dict.ahnentafel.kind[kind]["Throwability"]
						flag = flag && (throwability == 1)
				"Backline":
					flag = true
					
					for kind in data.drillinge.arr.kind:
						var throwability = dict.ahnentafel.kind[kind]["Throwability"]
						flag = flag && (throwability > 1)
			if flag:
				data.drillinge.arr.tag.append(tag)
	#tag 0: 34.2
	#tag 1: 32.5
	#tag 2: 11.5
	#tag 3: 2.7


func init_arr() -> void:
	arr.sequence = {} 
	arr.sequence["A000040"] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
	arr.sequence["A000045"] = [89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 1]
	arr.sequence["A000124"] = [7, 11, 16] #, 22, 29, 37, 46, 56, 67, 79, 92, 106, 121, 137, 154, 172, 191, 211]
	arr.sequence["A001358"] = [4, 6, 9, 10, 14, 15, 21, 22, 25, 26]
	arr.sequence["B000000"] = [2, 3, 5, 8, 10, 13, 17, 20, 24, 29, 33, 38]
	arr.color = ["Red","Green","Blue","Yellow"]
	arr.delta = [3,4,5,6,7,8,9]#[2,3,4,5,6,7,8,9,10]
	arr.bereich = ["deck","discard","hand","exile"]
	arr.layer = ["Top","Mid","Bot"]
	arr.side = ["First","Second"]
	arr.defense_line = [0,100,300,600,1000,1400,1700,1900,2000]


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_flag() -> void:
	flag.click = false
	flag.stop = false


func init_vec() -> void:
	vec.size = {}


func init_scene() -> void:
	scene.spielkarte = load("res://scene/0/spielkarte/Spielkarte.tscn")
	scene.spieltisch = load("res://scene/0/spieltisch/Spieltisch.tscn")
	scene.kasino = load("res://scene/0/kasino/Kasino.tscn")
	scene.knopf = load("res://scene/1/knopf/Knopf.tscn")
	scene.schlitz = load("res://scene/1/schlitz/Schlitz.tscn")
	scene.zugang = load("res://scene/1/zugang/Zugang.tscn")
	scene.leinwand = load("res://scene/1/leinwand/Leinwand.tscn")
	scene.sektor = load("res://scene/2/sektor/Sektor.tscn")
	scene.schlachtfeld = load("res://scene/2/schlachtfeld/Schlachtfeld.tscn")
	scene.vorderseite = load("res://scene/2/vorderseite/Vorderseite.tscn")
	scene.bieter = load("res://scene/5/bieter/Bieter.tscn")
	scene.auktionslos = load("res://scene/5/auktionslos/Auktionslos.tscn")
	scene.versteigerung = load("res://scene/5/versteigerung/Versteigerung.tscn")
	scene.austausch = load("res://scene/5/austausch/Austausch.tscn")


func _ready() -> void:
	init_num()
	init_dict()
	init_arr()
	init_node()
	init_flag()
	init_vec()
	init_scene()


func get_random_element(arr_: Array):
	if arr_.size() == 0:
		print("!bug! empty array in get_random_element func")
		return null
	
	rng.randomize()
	var index_r = rng.randi_range(0, arr_.size()-1)
	return arr_[index_r]


func split_two_point(points_: Array, delta_: float):
	var a = points_.front()
	var b = points_.back()
	var x = (a.x+b.x*delta_)/(1+delta_)
	var y = (a.y+b.y*delta_)/(1+delta_)
	var point = Vector2(x, y)
	return point


func save(path_: String, data_: String):
	var path = path_+".json"
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.save(data_)
	file.close()


func load_data(path_: String):
	var file = FileAccess.open(path_,FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_manhattan_distance(a_: Vector3, b_: Vector3) -> int:
	var d = 0
	d += abs(a_.x-b_.x)
	d += abs(a_.y-b_.y)
	d += abs(a_.z-b_.z)
	return d
