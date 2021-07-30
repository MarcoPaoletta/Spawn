extends Control

# signals
signal enable_sound
signal disable_sound

# vars
var show_settings = false

# check sound spr state
func check_sound_spr_state():
	if g.switch_sound_spr_state == true:
		$Menu/Sound.text = "Desactivar sonido"
		$Arrow.hide()
		emit_signal("enable_sound")
	if g.switch_sound_spr_state == false:
		$Menu/Sound.text = "Activar sonido"
		$Arrow.show()
		emit_signal("disable_sound")
		
# check time_state
func check_time_state():
	if g.switch_time_state == true:
		$Counter.show()
		$Menu/SwitchTime.text = "Ocultar tiempo"
	if g.switch_time_state == false:
		$Counter.hide()
		$Menu/SwitchTime.text = "Mostrar tiempo"
		
# settings butt modulate
func settings_modulate():
	if $Settings.disabled == true:
		$Settings.modulate = Color(0.14902, 0.152941, 0.156863)
	else:
		$Settings.modulate = Color(1, 1, 1)
		
# process
func _process(_delta):
	settings_modulate()
	g.save_game()

# set env color
func set_env_color():
	if g.data["Settings"].has(name):
		VisualServer.set_default_clear_color(g.data["Settings"][name])
# ready
func _ready():
	g.load_game()
	check_time_state()
	check_sound_spr_state()
	set_env_color()
	
# label switch time
func _on_SwitchTime_pressed():
	g.switch_time_state = !g.switch_time_state
	check_time_state()

# reset popup conf
func _on_ResetConf_confirmed():
	g.deleate_all = 0
	g.deleate_last = 0
	g.spawn = 0
	g.tiempo = 0
	g.switch_sound_spr_state = true
	g.switch_time_state = true
	g.put_default_color = true
	check_sound_spr_state()
	check_time_state()
	g.save_game()
	get_tree().reload_current_scene()

# reset data pressed
func _on_Reset_pressed():
	$ResetConf.popup()

# timer
func _on_Timer_timeout():
	g.tiempo += 1
	$Counter.text = str(g.tiempo/60) + " : " + str(g.tiempo%60)

# settings butt pressed
func _on_Settings_pressed():
	show_settings = !show_settings
	if show_settings == true:
		$Menu.show()
	else:
		$Menu.hide()

# settings butt pressed
func _on_Sound_pressed():
	g.switch_sound_spr_state = !g.switch_sound_spr_state
	g.sound = !g.sound
	check_sound_spr_state()

# restart color butt pressed
func _on_RestartColor_pressed():
	g.put_default_color = !g.put_default_color
	g.put_default_color = true
