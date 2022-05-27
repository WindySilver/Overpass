extends Node2D

export var time_penalty = 2
export var level_time = 15

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.hide()
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI.update_time($LevelTimer.get_time_left())

func game_over():
	$Player.stop()
	$LevelTimer.stop()
	$UI.show_game_over()

func new_game():
	$OverpassTiles.clear()
	restore_obstacles()
	$Player.start($StartPosition.position)
	$LevelTimer.set_wait_time(level_time)
	$LevelTimer.start()
	$Player.show()

func _on_LevelTimer_timeout():
	game_over()

func restore_obstacles():
	var children = get_children()
	for child in children:
		if child.is_in_group("obstacles"):
			child.restore()

func timer_down():
	var time = $LevelTimer.get_time_left() - time_penalty
	$LevelTimer.stop()
	if (time <= 0):
		time = 0.1
	$LevelTimer.set_wait_time(time)
	$LevelTimer.start()


func _on_Player_creating_overpass():
	var mouse_pos = $OverpassTiles.world_to_map(get_local_mouse_position())
	$OverpassTiles.set_cellv(mouse_pos, 1)


func _on_Player_victory():
	$Player.stop()
	$LevelTimer.stop()
	$UI.show_victory()
