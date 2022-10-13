extends StaticBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_VisibilityNotifier2D_screen_entered() -> void:
	visible = true
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited() -> void:
	visible = false

	pass # Replace with function body.
