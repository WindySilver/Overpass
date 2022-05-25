extends CanvasLayer

signal start_game



# Called when the node enters the scene tree for the first time.
func _ready():
	$Message.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_message(text):
	$Message.text = text
	$Message.show()

func show_game_over():
	show_message("Game Over")
	$StartButton.show()

func update_time(time):
	var add = str(time)
	$TimeLabel.text = add.substr(0, add.find(".", 0)+2)

func _on_StartButton_pressed():
	$StartButton.hide()
	$Message.hide()
	emit_signal("start_game")
