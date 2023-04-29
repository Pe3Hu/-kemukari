extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	$Labels/Name.text = parent.word.type + " " + str(parent.num.stack)
	update_members()



func update_members() -> void:
	$Labels/Members.text = "Members: " + str(parent.arr.bieter.size())
