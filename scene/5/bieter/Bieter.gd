extends MarginContainer


var parent = null

func set_parent(parent_) -> void:
	parent = parent_
	$HBox/Callsign.text = parent.word.callsign
	update_nums()


func update_nums() -> void:
	$HBox/Stage.text = "#"+str(parent.obj.schatzamt.num.aether.stage)
	$HBox/Aether.text = str(parent.obj.schatzamt.num.aether.current)+"/"+str(parent.obj.schatzamt.num.aether.max)
	$HBox/Gold.text = str(parent.obj.schatzamt.num.gold.current)+"G"
