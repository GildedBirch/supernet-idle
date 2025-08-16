extends Node


var first_octet: int = 0
var second_octet: int = 0
var third_octet: int = 0
var fourth_octet: int = 0

var scrape_time: float = 20.0 ## Time to scrape one fourth octet
var unparsed_data: int = 0 ## Unparsed data that's been downloaded
var valued_data: int = 0 ## Data that was successfully parsed
var junk_data: int = 0 ## Data that failed to parse
var data_storage_size: int = 30 ## Maxium data storage for data

var prestige: int = 0 ## Counter for fully scraping the supernet


## Save game to JSON file
func save_game() -> bool:
	var save_data: Dictionary = {
		"octets": {
			"first": first_octet,
			"second": second_octet,
			"third": third_octet,
			"fourth": fourth_octet,
		},
		"scrape_time": scrape_time,
		"unparsed_data": unparsed_data,
		"data_storage": data_storage_size,
		"valued_data": valued_data,
		"junk_data": junk_data,
		"prestige": prestige,
	}
	
	var save_file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if save_file == null:
		print(FileAccess.get_open_error())
		return false
	var data: String = JSON.stringify(save_data)
	save_file.store_line(data)
	save_file.close()
	
	return true


func load_game() -> bool:
	if not FileAccess.file_exists("user://savegame.json"):
		print("no save file")
		return false

	var save_file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var json_string = save_file.get_line()

	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

	var node_data = json.data
	first_octet = int(node_data["octets"]["first"])
	second_octet = int(node_data["octets"]["second"])
	third_octet = int(node_data["octets"]["third"])
	fourth_octet = int(node_data["octets"]["fourth"])
	scrape_time = node_data["scrape_time"]
	unparsed_data = int(node_data["unparsed_data"])
	data_storage_size = int(node_data["data_storage"])
	valued_data = int(node_data["valued_data"])
	junk_data = int(node_data["junk_data"])
	return true
