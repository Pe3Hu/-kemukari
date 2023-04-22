extends MarginContainer


func set_status(parent_):
	if parent_.obj.nachzucht == null:
		$VBoxContainer.visible = false
	
	if parent_.word.owner == "None":
		var path = "res://asset/png/sektor/filled.png"
		var texture = load(path)
		$BG.set_texture(texture)
