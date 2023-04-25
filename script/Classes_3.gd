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


	func get_priority(vorderseite_) -> void:
		var custom_biomass = 12000
		var current_biomass = obj.mutter.obj.staatskasse.num.stock.biomass.current
		dict.vorderseite = {}
		dict.vorderseite[vorderseite_] = {}
		dict.vorderseite[vorderseite_].biomass = {}
		dict.vorderseite[vorderseite_].biomass.total = min(current_biomass,custom_biomass)
		dict.vorderseite[vorderseite_].correlation = {}
		
		var custom_biomass_priority = {}
		custom_biomass_priority["Top"] = 10
		custom_biomass_priority["Mid"] = 16
		custom_biomass_priority["Bot"] = 8
		var total_priority = 0
		var custom_task_correlation = {}
		
		for layer in custom_biomass_priority.keys():
			total_priority += custom_biomass_priority[layer]
			custom_task_correlation[layer] = {}
		
		custom_task_correlation["Top"].offense = 1.0
		custom_task_correlation["Top"].retention = 0.75
		custom_task_correlation["Mid"].offense = 1.0
		custom_task_correlation["Mid"].retention = 0.5
		custom_task_correlation["Bot"].offense = 1.0
		custom_task_correlation["Bot"].retention = 1.25
		
		for layer in vorderseite_.dict.schlachtfeld.keys():
			var schlachtfeld = vorderseite_.dict.schlachtfeld[layer]
			var biomass = dict.vorderseite[vorderseite_].biomass.total*custom_biomass_priority[layer]/total_priority
			dict.vorderseite[vorderseite_].biomass[layer] = biomass
			dict.vorderseite[vorderseite_].correlation[layer] = custom_task_correlation[layer]


	func strategize(vorderseite_) -> void:
		var biomass_expenses = {}
		var task_correlation = {}
		
		for layer in vorderseite_.dict.schlachtfeld.keys():
			biomass_expenses[layer] = 0
			task_correlation[layer] = {}
			
			for key in dict.vorderseite[vorderseite_].correlation[layer]:
				task_correlation[layer][key] = null
		
		var flag_expense = true
		var counter = 0
		print(dict.vorderseite[vorderseite_])
		
		while flag_expense:
			print("deliberate # ", counter)
			deliberate(vorderseite_, biomass_expenses, task_correlation)
			
			for layer in biomass_expenses.keys(): 
				biomass_expenses[layer] += 1000
			
			flag_expense = false
			counter += 1


	#обдумать предложение
	func deliberate(vorderseite_, biomass_expenses_, task_correlation_) -> void:
		var angebot = obj.mutter.obj.geburtsteich.obj.angebot
		print(biomass_expenses_)
		print(task_correlation_)
		angebot.get_new()
		
		if task_correlation_["Top"].offense == null:
			set_keynote(vorderseite_, biomass_expenses_, task_correlation_, angebot)


	func set_keynote(vorderseite_, biomass_expenses_, task_correlation_, angebot_) -> void:
		var datas = []
		var tasks = ["offense", "retention"]
		var biomass_ratio = {}
		
		for layer in biomass_expenses_.keys():
			biomass_ratio[layer] = float(dict.vorderseite[vorderseite_].biomass[layer])/dict.vorderseite[vorderseite_].biomass.total
		
		print("biomass ratio",biomass_ratio)
		
		for drillinge in angebot_.arr.drillinge:
			var data = {}
			data.drillinge = drillinge
			data.correlation = {}
			data.correlation.task = {}
			data.correlation.biomass = {}
			data.proximity = {}
			data.proximity.task = {}
			data.proximity.biomass = {}
			data.correlation.task = drillinge.num["retention"]/drillinge.num["offense"]
			
			data.correlation.biomass = float(drillinge.num.biomass)/angebot_.num.biomass
			
			var total_proximity = {}
			total_proximity.task = 0
			total_proximity.biomass = 0
			
			for layer in biomass_ratio.keys():
				data.proximity.task[layer] = 1/abs(data.correlation.task-dict.vorderseite[vorderseite_].correlation[layer]["retention"])
				total_proximity.task += data.proximity.task[layer]
				data.proximity.biomass[layer] = 1/abs(data.correlation.biomass-biomass_ratio[layer])
				total_proximity.biomass += data.proximity.biomass[layer]
			
			for layer in biomass_ratio.keys():
				data.proximity.biomass[layer] = round(data.proximity.biomass[layer]/total_proximity.biomass*100)
				data.proximity.task[layer] = round(data.proximity.task[layer]/total_proximity.task*100)
			
			data.weight = {}
			var total_weight = 0
			
			for layer in biomass_ratio.keys(): 
				data.weight[layer] = 0
				
				for key in data.proximity.keys():
					data.weight[layer] += data.proximity[key][layer]*num.weight[key]
				
				total_weight += data.weight[layer]
			
			for layer in biomass_ratio.keys(): 
				data.weight[layer] = round(data.weight[layer]/total_weight*100)
			
			datas.append(data)
		
		for data in datas:
			pass

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
