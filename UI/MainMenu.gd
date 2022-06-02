extends CanvasLayer


# Goes to the level selection view when the button for it is pressed
func _on_StartButton_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://UI/LevelSelection.tscn")


# Goes to the item view when the button for it is pressed
func _on_ItemButton_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://UI/ItemUI.tscn")


# Goes to the credits view when the button for it is pressed
func _on_CreditsButton_pressed():
	UISound.play_sound()
	$StartButton.hide()
	$ItemButton.hide()
	$CreditsButton.hide()
	$Credits.show()
	$ReturnButton.show()
	$Text.text = "Credits"


# Returns to the main menu when the button for it is pressed
func _on_ReturnButton_pressed():
	UISound.play_sound()
	$StartButton.show()
	$ItemButton.show()
	$CreditsButton.show()
	$Credits.hide()
	$ReturnButton.hide()
	$Text.text = "Overpass"
