extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_


func update_status():
	if parent.obj.nachzucht == null:
		$VBoxContainer.visible = false
	else:
		$VBoxContainer.visible = true
		$VBoxContainer/Name.text = parent.obj.nachzucht.word.kind
	
	if parent.word.owner == "None":
		var path = "res://asset/png/sektor/filled.png"
		var texture = load(path)
		$BG.set_texture(texture)
