extends Node2D

export(PackedScene) var obstacle_scene
export var time_penalty = 2
export var level_time = 15

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI.update_time($LevelTimer.get_time_left())

func game_over():
	$Player.stop()
	$LevelTimer.stop()
	$ObstacleTimer.stop()
	$UI.show_game_over()

func new_game():
	get_tree().call_group("obstacles", "queue_free")
	$Player.start($StartPosition.position)
	$LevelTimer.set_wait_time(level_time)
	$LevelTimer.start()
	$ObstacleTimer.start()
	$Player.show()


func _on_LevelTimer_timeout():
	game_over()


func _on_ObstacleTimer_timeout():
	var obstacle = obstacle_scene.instance()
	
	var obstacle_spawn_location = get_node("SpawnArea")
	obstacle.position = obstacle_spawn_location.position
	
	add_child(obstacle)



func timer_down():
	var time = $LevelTimer.get_time_left() - time_penalty
	$LevelTimer.stop()
	if (time <= 0):
		time = 0.1
	$LevelTimer.set_wait_time(time)
	$LevelTimer.start()


func _on_Player_creating_overpass():
	var mouse_pos = $TileMap.world_to_map(get_local_mouse_position())
	$TileMap.set_cellv(mouse_pos, 1)
