extends Position2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


func _on_VisibilityNotifier2D_screen_entered() -> void:
	visible = true
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited() -> void:
	visible = false

	pass # Replace with function body.
