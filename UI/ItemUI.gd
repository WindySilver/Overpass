extends CanvasLayer

var items = {"Jewel": false, "Undefined": false, "Book": false, "Coin": false, "Heart": false, "Floppy": false} # The list of items the player can collect


# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	hide_unfound_items()


# Hides the items that have not been found by the player
func hide_unfound_items():
	if !items.Jewel:
		$Jewel.hide()
	if !items.Undefined:
		$Undefined.hide()
	if !items.Book:
		$Book.hide()
		$BookText.hide()
	if !items.Coin:
		$Coin.hide()
		$CoinText.hide()
	if !items.Heart:
		$Heart.hide()
	if !items.Floppy:
		$Floppy.hide()


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


# Returns to the main menu when the return button is pressed
func _on_ReturnButton_pressed():
	UISound.play_sound()
	var _change = get_tree().change_scene("res://UI/MainMenu.tscn")
