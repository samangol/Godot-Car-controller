extends CanvasLayer

var stats = []
	
func _ready() -> void:
	pass
	
func add_stats(statName,object,statRef, is_method):
	stats.append([statName,object,statRef,is_method])
	
func _process(delta: float) -> void:
	var labelText = ''
	
	var fps = Engine.get_frames_per_second()
	labelText += str('FPS: ', fps)
	labelText += '\n'
	
	var mem = OS.get_static_memory_usage()
	labelText += str('Static Memory: ', String.humanize_size(mem))
	labelText += '\n'
	
	for s in stats:
		var value = null
		if s[1] and weakref(s[1]).get_ref():
			if s[3]:
				value=s[1].call(s[2])
			else:
				value=s[1].get(s[2])
		labelText += str(s[0], ': ', value)
		labelText += '\n'
	$Label.text = labelText
