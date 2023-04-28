extends VBoxContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	$House.text = parent.word.house
	$Round.text = "Round " + str(parent.num.round.current)


func next_round() -> void:
	if parent.num.round.current <= parent.num.round.max:
		parent.num.round.current += 1
		$Round.text = "Round " + str(parent.num.round.current)
		
		if parent.num.round.current > parent.num.round.max:
			parent.payouts()
