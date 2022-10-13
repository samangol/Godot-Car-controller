extends Node2D

var debug_overlay = preload('res://debug_overlay.tscn')


func _ready() -> void:
	debug_overlay = debug_overlay.instance()
	add_child(debug_overlay)
	debug_overlay.add_stats('vel',$Car_rigid,'linear_velocity', false)
	debug_overlay.add_stats('force',$Car_rigid,'applied_impulse', false)
#	debug_overlay.add_stats('vel length',$Car.velocity,'length()', true)
	debug_overlay.add_stats('steering rotation x',$Car,'rotation_degrees', false)
	debug_overlay.add_stats('RPM', $Car_rigid, 'rpm_counter', false)
	debug_overlay.add_stats('GEAR', $Car_rigid, 'gear', false)
	
