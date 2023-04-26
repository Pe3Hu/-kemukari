extends Node


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
		num.stock.biomass.max = 12000
		num.stock.biomass.current = num.stock.biomass.max
		num.expense = {}
		num.expense.biomass = 0


#Пруд рождения
class Geburtsteich:
	var arr = {}
	var obj = {}
	var dict = {}


	func _init(input_) -> void:
		obj.mutter = input_.mutter
		dict.replenishment = {}
		init_angebot()


	func init_angebot() -> void:
		var input = {}
		input.geburtsteich = self
		obj.angebot = Classes_4.Angebot.new(input)


	func add_to_replenishment(schlachtfeld_, drillinge_) -> void:
		if !dict.replenishment.keys().has(schlachtfeld_):
			dict.replenishment[schlachtfeld_] = []
		
		dict.replenishment[schlachtfeld_].append_array(drillinge_.arr.kind)
		obj.mutter.obj.staatskasse.num.expense.biomass += drillinge_.num.biomass


	func give_birth(vorderseite_) -> void:
		obj.mutter.obj.staatskasse.num.stock.biomass.current -= obj.mutter.obj.staatskasse.num.expense.biomass
		
		for layer in vorderseite_.dict.schlachtfeld.keys():
			var schlachtfeld = vorderseite_.dict.schlachtfeld[layer]
			
			for kind in dict.replenishment[schlachtfeld]:
				var input = {}
				input.mutter = obj.mutter
				input.kind = kind
				input.vorderseite = vorderseite_
				input.layer = layer
				var nachzucht = Classes_4.Nachzucht.new(input)
				vorderseite_.arr.march.append(nachzucht)


#Полководец
class Kriegsherr:
	var num = {}
	var obj = {}
	var dict = {}


	func _init(input_) -> void:
		obj.mutter = input_.mutter
		init_weights()


	func init_weights() -> void:
		num.weight = {}
		num.weight.task = 2
		num.weight.biomass = 1
		num.weight.line = 1


	func get_priority(vorderseite_) -> void:
		var custom_biomass = 12000
		var current_biomass = obj.mutter.obj.staatskasse.num.stock.biomass.current
		dict.priority = {}
		dict.priority[vorderseite_] = {}
		dict.priority[vorderseite_].biomass = {}
		dict.priority[vorderseite_].biomass.total = min(current_biomass,custom_biomass)
		dict.priority[vorderseite_].task = {}
		dict.priority[vorderseite_].line = {}
		
		var custom_biomass_priority = {}
		custom_biomass_priority["Top"] = 10
		custom_biomass_priority["Mid"] = 16
		custom_biomass_priority["Bot"] = 8
		var total_priority = 0
		var custom_task_correlation = {}
		var custom_lines_correlation = {}
		
		for layer in custom_biomass_priority.keys():
			total_priority += custom_biomass_priority[layer]
			custom_task_correlation[layer] = {}
			custom_lines_correlation[layer] = {}
		
		custom_task_correlation["Top"].offense = 1.0
		custom_task_correlation["Top"].retention = 0.75
		custom_task_correlation["Mid"].offense = 1.0
		custom_task_correlation["Mid"].retention = 0.5
		custom_task_correlation["Bot"].offense = 1.0
		custom_task_correlation["Bot"].retention = 1.25
		
		custom_lines_correlation["Top"].frontline = 1.0
		custom_lines_correlation["Top"].backline = 0.8
		custom_lines_correlation["Mid"].frontline = 1.2
		custom_lines_correlation["Mid"].backline = 1.0
		custom_lines_correlation["Bot"].frontline = 1.0
		custom_lines_correlation["Bot"].backline = 0.4
		
		for layer in vorderseite_.dict.schlachtfeld.keys():
			var schlachtfeld = vorderseite_.dict.schlachtfeld[layer]
			var biomass = dict.priority[vorderseite_].biomass.total*custom_biomass_priority[layer]/total_priority
			dict.priority[vorderseite_].biomass[layer] = biomass
			dict.priority[vorderseite_].task[layer] = custom_task_correlation[layer]
			dict.priority[vorderseite_].line[layer] = custom_lines_correlation[layer]


	func strategize(vorderseite_) -> void:
		var biomass_expenses = {}
		var task_correlation = {}
		
		for layer in vorderseite_.dict.schlachtfeld.keys():
			biomass_expenses[layer] = 0
			task_correlation[layer] = {}
			
			for key in dict.priority[vorderseite_].task[layer]:
				task_correlation[layer][key] = null
		
		var bankrupts = 0
		var bankrupts_limit = 3
		
		while bankrupts < bankrupts_limit:
			if deliberate(vorderseite_, biomass_expenses, task_correlation):
				bankrupts += 1


	#обдумать предложение
	func deliberate(vorderseite_, biomass_expenses_, task_correlation_) -> bool:
		var angebot = obj.mutter.obj.geburtsteich.obj.angebot
		angebot.get_new()
		var bankrupts = []
		
		if task_correlation_["Top"].offense == null:
			var distribution = set_keynote(vorderseite_, biomass_expenses_, task_correlation_, angebot)
			add_to_replenishment(distribution)
			
			for layer in distribution.keys(): 
				if distribution[layer] != null:
					biomass_expenses_[layer] += distribution[layer].drillinge.num.biomass
				else:
					bankrupts.append(layer)
		
		return bankrupts.size() == task_correlation_.keys().size()


	func set_keynote(vorderseite_, biomass_expenses_, task_correlation_, angebot_) -> Dictionary:
		var datas = []
		var tasks = ["offense", "retention"]
		var biomass_ratio = {}
		
		for layer in biomass_expenses_.keys():
			biomass_ratio[layer] = float(dict.priority[vorderseite_].biomass[layer])/dict.priority[vorderseite_].biomass.total
		
		#print("biomass ratio",biomass_ratio)
		
		for drillinge in angebot_.arr.drillinge:
			var data = {}
			data.drillinge = drillinge
			data.correlation = {}
			data.correlation.task = {}
			data.correlation.biomass = {}
			data.proximity = {}
			data.proximity.task = {}
			data.proximity.biomass = {}
			data.proximity.line = {}
			data.correlation.task = drillinge.num["retention"]/drillinge.num["offense"]
			
			data.correlation.biomass = float(drillinge.num.biomass)/angebot_.num.biomass
			
			var total_proximity = {}
			total_proximity.task = 0
			total_proximity.biomass = 0
			total_proximity.line = 0
			var line = {}
			
			for key in dict.priority[vorderseite_].line["Top"].keys():
				line[key] = 0
				
				for layer in biomass_ratio.keys():
					data.proximity.line[layer] = 0
			
			for kind in drillinge.arr.kind:
				var ahnentafel = Global.dict.ahnentafel.kind[kind]
				
				if ahnentafel["Throwability"] == 1:
					line["frontline"] += 1
				if ahnentafel["Throwability"] > 1:
					line["backline"] += 1
			
			for layer in biomass_ratio.keys():
				data.proximity.line[layer] = 0
				var sizes = {}
				
				for key in line.keys():
					sizes[key] = float(vorderseite_.dict.schlachtfeld[layer].num.size)*dict.priority[vorderseite_].line[layer][key]
				
				for key in line.keys():
					for _i in line[key]:
						data.proximity.line[layer] += sizes[key]
						sizes[key] -= 1
				
				total_proximity.line += data.proximity.line[layer]
		
			for layer in biomass_ratio.keys():
				data.proximity.task[layer] = 1/abs(data.correlation.task-dict.priority[vorderseite_].task[layer]["retention"])
				total_proximity.task += data.proximity.task[layer]
				data.proximity.biomass[layer] = 1/abs(data.correlation.biomass-biomass_ratio[layer])
				total_proximity.biomass += data.proximity.biomass[layer]
			
			for layer in biomass_ratio.keys():
				data.proximity.biomass[layer] = round(data.proximity.biomass[layer]/total_proximity.biomass*100)
				data.proximity.task[layer] = round(data.proximity.task[layer]/total_proximity.task*100)
				data.proximity.line[layer] = round(data.proximity.line[layer]/total_proximity.line*100)
			
			data.weight = {}
			var total_weight = 0
			
			for layer in biomass_ratio.keys(): 
				data.weight[layer] = 0
				
				for key in data.proximity.keys():
					var affordable = dict.priority[vorderseite_].biomass[layer]-biomass_expenses_[layer]-drillinge.num.biomass
					
					if affordable > 0:
						data.weight[layer] += data.proximity[key][layer]*num.weight[key]
				
				total_weight += data.weight[layer]
			
			if total_weight > 0:
				for layer in biomass_ratio.keys(): 
					data.weight[layer] = round(data.weight[layer]/total_weight*100)
				
				datas.append(data)
		
		return divide_drillinge_between_layers(vorderseite_, datas)


	func divide_drillinge_between_layers(vorderseite_, datas_) -> Dictionary:
		var distribution = {}
		var drillinges = []
		
		for data in datas_:
			if !drillinges.has(data.drillinge):
				drillinges.append(data.drillinge)
		
		for layer in vorderseite_.dict.schlachtfeld.keys():
			distribution[layer] = null
		
		for _i in distribution.keys().size():
			var options = []
			
			for data in datas_:
				if drillinges.has(data.drillinge):
					for layer in distribution.keys():
						if distribution[layer] == null:
							for _j in data.weight[layer]:
								var option = {}
								option.drillinge = data.drillinge
								option.layer = layer
								option.weight = data.weight[layer]
								option.schlachtfeld = vorderseite_.dict.schlachtfeld[layer]
								options.append(option)
			
			if options.size() > 0:
				options.shuffle()
				var option = Global.get_random_element(options)
				distribution[option.layer] = option
				drillinges.erase(option.drillinge)
		
		return distribution


	func add_to_replenishment(distribution_) -> void:
		for line in distribution_.keys():
			var data = distribution_[line]
			
			if data != null:
				obj.mutter.obj.geburtsteich.add_to_replenishment(data.schlachtfeld, data.drillinge)


	func combatant_arrangement(schlachtfeld_, side_) -> void:
		var sektor = schlachtfeld_.find_free_spot(side_)
		
		for _i in range(schlachtfeld_.dict.bench[side_].size()-1,-1,-1):
			var nachzucht = schlachtfeld_.dict.bench[side_][_i]
			nachzucht.set_sektor(sektor)
			schlachtfeld_.dict.bench[side_].erase(nachzucht)
			schlachtfeld_.dict.combatant[side_].append(nachzucht)
		
		if schlachtfeld_.word.layer == "Bot":
			print(schlachtfeld_.dict.bench[side_].size(),schlachtfeld_.dict.combatant[side_].size())


#Матерь
class Mutter:
	var obj = {}
	var dict = {}


	func _init(input_) -> void:
		obj.planet = input_.planet
		dict.vorderseite = {}
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


	func battle_preparation(vorderseite_) -> void:
		dict.vorderseite[vorderseite_] = true
		obj.kriegsherr.get_priority(vorderseite_)
		obj.kriegsherr.strategize(vorderseite_)
		obj.geburtsteich.give_birth(vorderseite_) 
		
		var nachzuchts = []
		for nachzucht in vorderseite_.arr.march:
			if nachzucht.word.layer == "Bot":
				nachzuchts.append(nachzucht.word.kind)
		
		print(nachzuchts.size())
