extends CanvasLayer

var items = {"Jewel": false, "Undefined": false, "Book": false, "Coin": false, "Heart": false, "Floppy": false} # The list of items the player can collect


# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	hide_clear()


func hide_clear():
	if !items.Jewel or !items.Undefined:
		$ClearLevel1.hide()
	if !items.Book or !items.Coin:
		$ClearLevel2.hide()
	if !items.Heart or !items.Floppy:
		$ClearLevel3.hide()


# Loads the save file to check for found items
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var item_data = parse_json(save_game.get_line())
		items.Jewel = item_data.jewel
		items.Undefined = item_data.undefined
		items.Book = item_data.book
		items.Coin = item_data.coin
		items.Heart = item_data.heart
		items.Floppy = item_data.floppy
		
	save_game.close()


# Returns to main menu when the button for it is pressed
func _on_ReturnButton_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://UI/MainMenu.tscn")


# Loads level 1 when the button for it is pressed
func _on_Level1_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://Levels/Level1.tscn")


# Loads level 2 when the button for it is pressed
func _on_Level2_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://Levels/Level2.tscn")


# Loads level 3 when the button for it is pressed
func _on_Level3_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://Levels/Level3.tscn")
