extends Node2D

var debug_overlay = preload('res://debug_overlay.tscn')


func _ready() -> void:
	debug_overlay = debug_overlay.instance()
	add_child(debug_overlay)
	debug_overlay.add_stats('vel',$Car_rigid,'linear_velocity', false)
	debug_overlay.add_stats('RPM', $Car_rigid, 'rpm_counter', false)
	debug_overlay.add_stats('linear damp', $Car_rigid, 'linear_damp', false)
	debug_overlay.add_stats('GEAR', $Car_rigid, 'gear', false)
	

