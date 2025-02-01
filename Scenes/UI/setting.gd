extends Control

var proj_set_hdr = ProjectSettings.get_setting("rendering/viewport/hdr_2d")

func _ready():
	self.hide()
	
func _on_exit_pressed():
	self.hide()

func _on_check_button_toggled(toggled_on):
	if toggled_on:
		proj_set_hdr = true
	else:
		proj_set_hdr = false

func _on_audio_toggled(toggled_on):
	if toggled_on:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
