extends Node2D

export var level_time = 15 # The time the player has to clear the level before game over
var player_flipped = false # Whether or not the player has been flipped around
var y_position = 0 # The y distance between player and victory point
var paused = false # Whether or not game is paused


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.hide()
	load_game()
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("restart"):
		new_game()
	if Input.is_action_pressed("pause"):
		pause_game()
	
	$UI.update_time($LevelTimer.get_time_left())

# Processes physics things and in this case things that are related to things
# processed by their own _physics_process functions
func _physics_process(_delta):
	y_position = $VictoryPoint.position.y - $Player.position.y
	$Music.position = $Player.position
	$FailAudio.position = $Player.position
	if !player_flipped and $Player.position.x > $VictoryPoint.position.x and y_position < 30:
		player_flipped = true
		$Player.velocity.x = $Player.velocity.x * -1
		$Player.flip_me()
	elif player_flipped and $Player.position.x < $VictoryPoint.position.x:
		player_flipped = false
		$Player.velocity.x = $Player.velocity.x * -1
		$Player.flip_me()


# Pauses the game and brings up the pause menu
func pause_game():
	$Music.set_stream_paused(true)
	$Player.stop()
	$LevelTimer.set_paused(true)
	$UI.show_pause_menu()
	paused = true


# Unpauses the game and hides the pause menu
func unpause_game():
	$Music.set_stream_paused(false)
	$Player.unstop()
	$LevelTimer.set_paused(false)
	paused = false


# Handles things that need to be done when the player fails the level
func game_over():
	$LevelTimer.set_paused(true)
	$Music.stop()
	play_fail_sound()
	$Player.stop()
	$UI.show_game_over()


# Starts/restarts the level
func new_game():
	if paused:
		$UI/Message.hide()
		$UI/ResumeButton.hide()
		$UI/StartButton.hide()
		$UI/MainMenuButton.hide()
		unpause_game()
	if $Player.velocity.x < 0:
		$Player.velocity.x = $Player.velocity.x * -1
	player_flipped = false
	$LevelTimer.set_paused(false)
	$OverpassTiles.clear()
	restore_obstacles_items()
	$Music.play()
	$Player.start($StartPosition.position)
	$LevelTimer.set_wait_time(level_time)
	$LevelTimer.start()
	$Player.show()


# Handles what happens when the time runs out
func _on_LevelTimer_timeout():
	game_over()


# Restores obstacles and items at the (re)start of the game
func restore_obstacles_items():
	var children = get_children()
	for child in children:
		if child.is_in_group("obstacles") or child.is_in_group("items"):
			child.restore()


# Decreases remaining time by the obstacle's time penalty when player hits it
func timer_down(var penalty):
	var time = $LevelTimer.get_time_left() - penalty
	$LevelTimer.stop()
	if (time <= 0):
		time = 0.1
	$LevelTimer.set_wait_time(time)
	$LevelTimer.start()


# Creates overpasses to the cursor's position when the button for it is pressed
func _on_Player_creating_overpass():
	var mouse_pos = $OverpassTiles.world_to_map(get_local_mouse_position())
	$OverpassTiles.set_cellv(mouse_pos, 1)


# Handles things that need to be done when the player clears the level
func _on_Player_victory():
	$LevelTimer.set_paused(true)
	$Music.stop()
	$Player.stop()
	$UI.show_victory()
	save_game()


# Saves the item and level clearance data
func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"jewel" : $Player.items.Jewel,
		"undefined" : $Player.items.Undefined,
		"book" : $Player.items.Book,
		"coin" : $Player.items.Coin,
		"heart" : $Player.items.Heart,
		"floppy" : $Player.items.Floppy,
	}
	return save_dict


# Saves the game's progress (namely item data)
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	# Store the save dictionary as a new line in the save file.
	save_game.store_line(to_json(save()))
	save_game.close()


# Loads the game's save file (namely item data)
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
		$Player.items.Jewel = item_data.jewel
		$Player.items.Undefined = item_data.undefined
		$Player.items.Book = item_data.book
		$Player.items.Coin = item_data.coin
		$Player.items.Heart = item_data.heart
		$Player.items.Floppy = item_data.floppy

	save_game.close()


# Plays the fail sound when player gets game over
func play_fail_sound():
	$FailAudio.play()
