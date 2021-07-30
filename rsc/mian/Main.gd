extends Node

# vars
	# window size
var width = 800
var heigth = 600

	# cube
var cube = preload("res://rsc/cube/Cube.tscn")
var cube_list = []

	# boolean vars
var can_deleate_last = false
var can_restart = false
var show_color_picker = false
var can_touch = false
	
# update labels
func update_labels():
	$UI/DeleateAllLabel.text = str(g.deleate_all)
	$UI/SpawnLabel.text = str(g.spawn)
	$UI/DeleateLastLabel.text = str(g.deleate_last)

# disabled buttons
func disabled_buttons():
	$UI/DeleateAll.disabled = true
	$UI/Spawn.disabled = true
	$UI/DeleateLast.disabled = true
	$UI/Settings.disabled = true
	
# enabled buttons
func enabled_buttons():
	$UI/DeleateAll.disabled = false
	$UI/Spawn.disabled = false
	$UI/DeleateLast.disabled = false
	$UI/Settings.disabled = false

# buttons state
func buttons_state():
	# disable buttons
	if can_touch == false:
		disabled_buttons()
	# enable buttons
	if can_touch == true:
		enabled_buttons()

# save default color
func default_bg_color():
	if g.put_default_color == true:
		$UI/Menu/ColorPicker.color = g.default_color
		VisualServer.set_default_clear_color(g.default_color)		
		g.data["Settings"][name] = g.default_color
		g.save_data()

# process
func _process(_delta):
	$UI/Counter.text = str(g.tiempo/60) + " : " + str(g.tiempo%60) # update time since the scene is launched	
	buttons_state() # changes buttons states
	update_labels() # updates labels text
	g.save_game()
	default_bg_color()
	
# save system for the color picker
func color_picker():
	if g.data["Settings"].has(name):
		VisualServer.set_default_clear_color(g.data["Settings"][name])
		
# ready
func _ready():
	randomize()
	g.load_game() # load the saved data
	color_picker()
		
# spawn cube
func _on_Spawn_pressed():
	can_deleate_last = true # boolean var
	if g.sound == true:
		$Tick.play() # play sound
		g.save_game() # save game
			
	# cube creation
	if can_touch == true:
		# label
		g.spawn += 1 # increase the var
		var cube_instance = cube.instance() # create instance
		$Container.add_child(cube_instance) # add child to a container
		cube_instance.global_position = Vector2(rand_range(0,width), rand_range(120,heigth - 150)) # randomize position
		cube_list.append(cube_instance) # add to the list the instance
		cube_instance.modulate = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1)) # random
	
# deleate all created cubes
func _on_DeleateAll_pressed():
	can_deleate_last = false # boolean var
	if can_touch == true: 
		if g.sound == true:
			if cube_list.empty(): # if the list does not have any element 
				$Error.play()
			else: # if it does
				$Confirmation.play() # play sound
				g.deleate_all += 1 # we will increase the var
		# remove the cube from the tree
		for cube in cube_list: 
			cube.queue_free()
		cube_list.clear() # remove the cube from the list
	g.save_game() # save game
			
# deleate just the last cube created
func _on_DeleateLast_pressed():
	if g.sound == true:
		if cube_list.empty(): # if the list does not have any element 
			$Error.play()
		else: # but if it does 
			$Confirmation.play() # play sound	
			# cube remove
			cube_list[cube_list.size()-1].queue_free() # remove the last cube from the tree
			cube_list.remove(cube_list.size()-1) # remove the last cube from the list
			g.deleate_last += 1 # increase the var
	g.save_game() # save game

# when the initial transition finishes
func _on_Animation_animation_finished(_anim_name):
	can_touch = true
	can_restart = true
	$UI/Timer.start()
	$Music.play()
	g.load_game()

# when the sound is disabled
func _on_UI_disable_sound():
	g.sound = false
	$Error.stream_paused = true
	$Music.stream_paused = true
	$Confirmation.stream_paused = true
	$Tick.stream_paused = true

# when the sound is enabled
func _on_UI_enable_sound():
	g.sound = true
	$Error.stream_paused = false
	$Music.stream_paused = false
	$Confirmation.stream_paused = false
	$Tick.stream_paused = false

func _on_Color_pressed():
	show_color_picker = !show_color_picker
	if show_color_picker == true:
		$UI/Menu/ColorPicker.show()
	if show_color_picker == false:
		$UI/Menu/ColorPicker.hide()

func _on_ColorPicker_color_changed(color):
	g.put_default_color = false
	VisualServer.set_default_clear_color(color)
	g.data["Settings"][name] = color
	g.save_data()
