extends VBoxContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	$House.text = parent.obj.dynastie.word.house
	$Round.text = "Round " + str(parent.num.round.current)


func update_members() -> void:
	$Members.text = "Members: " + str(parent.arr.bieter.size())


func next_round() -> void:
	if parent.num.round.current <= parent.num.round.max:
		parent.num.round.current += 1
		$Round.text = "Round " + str(parent.num.round.current)
		
		for bieter in parent.arr.bieter:
			bieter.obj.volkswirt.select_auktionslos()
		
		for auktionslos in parent.arr.auktionslos:
			auktionslos.scene.myself.update_members()
		
		if parent.num.round.current > parent.num.round.max:
			parent.payouts()
