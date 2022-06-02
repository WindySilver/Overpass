extends CanvasLayer

signal start_game
signal unpause


# Called when the node enters the scene tree for the first time.
func _ready():
	$Message.hide()
	$StartButton.hide()
	$MainMenuButton.hide()


# Chances the UI's text to the given text
func show_message(text):
	$Message.text = text
	$Message.show()


#Shows the game over menu
func show_game_over():
	show_message("Game Over")
	$StartButton.text = "Play again"
	$StartButton.show()
	$MainMenuButton.show()


#Shows the victory menu
func show_victory():
	show_message("Victory!")
	$StartButton.text = "Play again"
	$StartButton.show()
	$MainMenuButton.show()


# Formats the given time to a stable format
func update_time(time):
	var add = str(time)
	$TimeLabel.text = add.substr(0, add.find(".", 0)+2)


# Starts the game when the start button is pressed
func _on_StartButton_pressed():
	UISound.play_sound()
	$StartButton.hide()
	$Message.hide()
	$MainMenuButton.hide()
	emit_signal("start_game")


# Switches to main menu when the main menu button is pressed
func _on_MainMenuButton_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://UI/MainMenu.tscn")


# Shows the pause menu when middle mouse button (MMB) or equivalent button is pressed
func show_pause_menu():
	show_message("Paused")
	$ResumeButton.show()
	$MainMenuButton.show()


# Resumes the game when the resume button is pressed in the pause menu
func _on_ResumeButton_pressed():
	UISound.play_sound()
	$Message.hide()
	$MainMenuButton.hide()
	$ResumeButton.hide()
	emit_signal("unpause")
