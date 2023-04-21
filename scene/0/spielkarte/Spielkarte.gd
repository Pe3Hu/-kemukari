extends MarginContainer


func set_labes(parent_) -> void:
	$Labels/Kind.text = parent_.word.kind
	$Labels/Rank.text = str(parent_.num.rank)
