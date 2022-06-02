extends CanvasLayer


# Loads level 1 when the button for it is pressed
func _on_Level1_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://Levels/Level1.tscn")


# Loads level 2 when the button for it is pressed
func _on_Level2_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://Levels/Level2.tscn")


# Returns to main menu when the button for it is pressed
func _on_ReturnButton_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://UI/MainMenu.tscn")
