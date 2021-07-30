extends Node

# process
func _process(_delta):
	pass
	
func _ready():
	load_data()
	
# global vars
var put_default_color = false
var sound = true
var switch_sound_spr_state = true
var switch_time_state = true
var default_color = "39154f"
var tiempo : int = 0
var deleate_all = 0
var spawn = 0
var deleate_last = 0
	# saving
var data = {}
var file_name = "save.sv"

# save system X2
	# for save_dict
func save():
	var save_dictionary = {
		"tiempo": tiempo,
		"deleate_all": deleate_all, 
		"spawn": spawn,
		"deleate_last": deleate_last,
		"switch_sound_spr_state": switch_sound_spr_state,
		"switch_time_state": switch_time_state,
		"sound": sound
	}
	return save_dictionary

func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass("user://savegame.save", File.WRITE, "enc")
	save_game.store_line(to_json(save()))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return 
	save_game.open_encrypted_with_pass("user://savegame.save", File.READ, "enc")
	var current_line = parse_json(save_game.get_line())
	tiempo = current_line["tiempo"]
	deleate_all = current_line["deleate_all"]
	spawn = current_line["spawn"]
	deleate_last = current_line["deleate_last"]
	switch_sound_spr_state = current_line["switch_sound_spr_state"]
	switch_time_state = current_line["switch_time_state"]
	sound = current_line["sound"]
	save_game.close()
	
	# for data (bg colour)
func load_data():
	var file = File.new()
	if file.file_exists("user://"+file_name):
		file.open("user://"+file_name, File.READ)
		data = file.get_var()
		file.close()
	else:
		data = {
			"Settings": {}
		}
		
func save_data():
	var file = File.new()
	file.open("user://"+file_name, File.WRITE)
	file.store_var(data)
	file.close()
