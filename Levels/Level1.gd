extends Node

export(PackedScene) var obstacle_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$LevelTimer.stop()
	$ObstacleTimer.stop()
	print("Game over!")

func new_game():
	$Player.start($StartPosition.position)
	$LevelTimer.start()
	$ObstacleTimer.start()


func _on_LevelTimer_timeout():
	game_over()


func _on_ObstacleTimer_timeout():
	var obstacle = obstacle_scene.instance()
	
	var obstacle_spawn_location = get_node("SpawnArea")
	obstacle.position = obstacle_spawn_location.position
	
	add_child(obstacle)
