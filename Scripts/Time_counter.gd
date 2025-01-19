extends Control

var count_per_sec : int = 0

func _ready():
	$Timer.start()

func _on_timer_timeout():
	count_per_sec += 1
	var minutes = int(count_per_sec / 60.0)
	#var minutes = int(sec / 60.0)
	var sec = count_per_sec - minutes * 60 #if needed
	$Label.text = '%02d:%02d' % [ minutes, sec]
	#var frame_check = Engine.get_frames_per_second()
	#$Label2.text = '%03d' % [frame_check]
