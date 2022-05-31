extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	var _change = get_tree().change_scene("res://Levels/Level1.tscn")


func _on_ItemButton_pressed(): #TODO SHOW ITEMS
	var _change = get_tree().change_scene("res://UI/ItemUI.tscn")

func _on_CreditsButton_pressed():
	$StartButton.hide()
	$ItemButton.hide()
	$CreditsButton.hide()
	$ReturnButton.show()
	$Text.text = "Credits\nDeveloper: Noora Jokela\nMade with Godot"


func _on_ReturnButton_pressed(): #TODO RETURN TO MENU
	$StartButton.show()
	$ItemButton.show()
	$CreditsButton.show()
	$ReturnButton.hide()
	$Text.text = "Overpass"
