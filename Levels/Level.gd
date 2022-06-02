extends Node2D

export var time_penalty = 2
export var level_time = 15

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

func _physics_process(_delta):
	$Music.position = $Player.position
	$FailAudio.position = $Player.position

func pause_game():
	$Music.set_stream_paused(true)
	$Player.stop()
	$LevelTimer.set_paused(true)
	$UI.show_pause_menu()
	
func unpause_game():
	$Music.set_stream_paused(false)
	$Player.unstop()
	$LevelTimer.set_paused(false)

func game_over():
	$LevelTimer.set_paused(true)
	$Music.stop()
	play_fail_sound()
	$Player.stop()
	$UI.show_game_over()

func new_game():
	$LevelTimer.set_paused(false)
	$OverpassTiles.clear()
	restore_obstacles()
	$Music.play()
	$Player.start($StartPosition.position)
	$LevelTimer.set_wait_time(level_time)
	$LevelTimer.start()
	$Player.show()

func _on_LevelTimer_timeout():
	game_over()

func restore_obstacles():
	var children = get_children()
	for child in children:
		if child.is_in_group("obstacles") or child.is_in_group("items"):
			child.restore()

func timer_down(var penalty):
	var time = $LevelTimer.get_time_left() - penalty
	$LevelTimer.stop()
	if (time <= 0):
		time = 0.1
	$LevelTimer.set_wait_time(time)
	$LevelTimer.start()


func _on_Player_creating_overpass():
	var mouse_pos = $OverpassTiles.world_to_map(get_local_mouse_position())
	$OverpassTiles.set_cellv(mouse_pos, 1)


func _on_Player_victory():
	$LevelTimer.set_paused(true)
	$Music.stop()
	$Player.stop()
	$UI.show_victory()
	save_game()


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"jewel" : $Player.items.Jewel,
		"undefined" : $Player.items.Undefined
	}
	return save_dict

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	# Store the save dictionary as a new line in the save file.
	save_game.store_line(to_json(save()))
	save_game.close()

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
		
	save_game.close()


func play_fail_sound():
	$FailAudio.play()