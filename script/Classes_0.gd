extends Node


#Крупье
class Croupier:
	var num = {}
	var obj = {}
	var dict = {}


	func _init(input_) -> void:
		num.draw = {}
		num.draw.base = input_.draw
		num.draw.current = num.draw.base
		obj.spieler = input_.spieler
		init_bereichs()


	func init_bereichs() -> void:
		dict.bereich = {}
		
		for bereich in Global.arr.bereich:
			dict.bereich[bereich] = []
		
		for spielkarte in obj.spieler.arr.spielkarte:
			dict.bereich.deck.append(spielkarte)
		
		fill_hand()


	func discard_hand() -> void:
		while dict.bereich.hand.size() > 0:
			var spielkarte = dict.bereich.hand.pop_front()
			dict.bereich.discard.append(spielkarte)
			obj.spieler.obj.spieltisch.scene.myself.remove_from_hand(spielkarte)


	func draw_spielkarte() -> void:
		if dict.bereich.deck.size() > 0:
			var spielkarte = dict.bereich.deck.pop_front()
			dict.bereich.hand.append(spielkarte)
			obj.spieler.obj.spieltisch.scene.myself.add_in_hand(spielkarte)
		else:
			regain_discard()


	func regain_discard() -> void:
		while dict.bereich.discard.size() > 0:
			dict.bereich.deck.append(dict.bereich.discard.pop_front())


	func fill_hand() -> void:
			discard_hand()
			dict.bereich.deck.shuffle()
			
			while dict.bereich.hand.size() < num.draw.current:
				draw_spielkarte()


#Игрок
class Spieler:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		obj.spieltisch = input_.spieltisch
		init_spielkartes()
		init_croupier()


	func init_croupier() -> void:
		var input = {}
		input.draw = 5
		input.spieler = self
		obj.croupier = Classes_0.Croupier.new(input)
		obj.croupier.fill_hand()


	func init_scene() -> void:
		scene.myself = Global.scene.spieler.instantiate()
		Global.node.game.get_node("Layer0").add_child(scene.myself)


	func init_spielkartes() -> void:
		arr.spielkarte = []
		var kinds = ["A","B","C","D"]
		var ranks = [0,1,2,2,3,4,5,6,7,8,9]
		
		for kind in kinds:
			for rank in ranks:
				var input = {}
				input.spieler = self
				input.kind = kind
				input.rank = rank
				var spielkarte = Classes_0.Spielkarte.new(input)
				arr.spielkarte.append(spielkarte)


#Игральная карта
class Spielkarte:
	var obj = {}
	var num = {}
	var word = {}
	var scene = {}


	func _init(input_) -> void:
		obj.spieler = input_.spieler
		word.kind = input_.kind
		num.rank = input_.rank
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.spielkarte.instantiate()
		set_labes()


	func set_labes() -> void:
		scene.myself.set_labes(self)


#Игровой стол
class Spieltisch:
	var obj = {}
	var arr = {}
	var scene = {}


	func _init(input_) -> void:
		obj.kasino = input_.kasino
		init_scene()
		init_spielers()


	func init_spielers() -> void:
		arr.spieler = []
		var n = 1
		
		for _i in n:
			var input = {}
			input.spieltisch = self
			var spieler = Classes_0.Spieler.new(input)
			arr.spieler.append(spieler)

	func init_scene() -> void:
		scene.myself = Global.scene.spieltisch.instantiate()
		Global.node.game.get_node("Layer0").add_child(scene.myself)


#Казино
class Kasino:
	var obj = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_spieltisch()


	func init_scene() -> void:
		scene.myself = Global.scene.kasino.instantiate()
		Global.node.game.get_node("Layer0").add_child(scene.myself)


	func init_spieltisch() -> void:
		var input = {}
		input.kasino = self
		obj.spieltisch = Classes_0.Spieltisch.new(input)
