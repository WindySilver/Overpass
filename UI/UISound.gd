extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_sound():
	$Audio.play()


func play_fail_sound():
	$FailAudio.play()