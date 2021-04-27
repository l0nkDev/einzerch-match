extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _start_button_p():
	$menu2bckg/Animation.play("menu")


func _on_backbutton1_button_up():
	$menu2bckg/Animation.play_backwards("menu")
