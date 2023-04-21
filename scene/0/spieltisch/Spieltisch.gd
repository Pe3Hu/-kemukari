extends Control


func add_in_hand(spielkarte_):
	$Hand.add_child(spielkarte_.scene.myself)


func remove_from_hand(spielkarte_):
	$Hand.remove_child(spielkarte_.scene.myself)
