extends CanvasLayer

onready var texture_progress: TextureProgress = $Control/TextureProgress
onready var label: Label = $Control/Label
onready var label_2: Label = $Control/Label2
onready var player =get_node('../Car_rigid')

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	label.text = str(player.gear)
	label_2.text = str(round(player.linear_velocity.length()/10), ' : Kph')
	texture_progress.max_value = 1000
	texture_progress.value = player.rpm_counter
	pass



func _on_Button_pressed() -> void:
	get_tree().quit()


func _on_Button2_pressed() -> void:
	get_tree().reload_current_scene()
