extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://UI/LevelSelection.tscn")


func _on_ItemButton_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://UI/ItemUI.tscn")

func _on_CreditsButton_pressed():
	UISound.play_sound()
	$StartButton.hide()
	$ItemButton.hide()
	$CreditsButton.hide()
	$Credits.show()
	$ReturnButton.show()
	$Text.text = "Credits"


func _on_ReturnButton_pressed():
	UISound.play_sound()
	$StartButton.show()
	$ItemButton.show()
	$CreditsButton.show()
	$Credits.hide()
	$ReturnButton.hide()
	$Text.text = "Overpass"
