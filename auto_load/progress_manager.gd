extends Node


const _first_octet_increase: float = 5.0
const _second_octet_increase: float = 2.5
const _third_octet_increase: float = 1.0
const _fourth_octet_increase: float = 0.1

var first_octet: int = 0
var second_octet: int = 0
var third_octet: int = 0
var fourth_octet: int = 0

## Time to scrape one fourth octet
var scrape_time: float = 0.5
## How much unparsed data each successful scrape gives
var data_per_scrape: int = 1
## Unparsed data that's been downloaded
var unparsed_data: int = 0
## Data that was successfully parsed
var valued_data: int = 0
## Data that failed to parse
var junk_data: int = 0
## Maxium data storage for data
var data_storage_size: int = 30
## Penetration power of scraping
var penetration_power: float = 0.5
## Strength of the firewall. will increase each successful scrape
var firewall_strength: float = 1.0
## Counter for fully scraping the supernet
var prestige: int = 0
@onready var scrape_timer: Timer = %ScrapeTimer


func _ready() -> void:
	scrape_timer.timeout.connect(_on_scrape_timer_timeout)
	scrape_timer.wait_time = scrape_time
	scrape_timer.start()
	_print_chances()


func _process(delta: float) -> void:
	#TODO limit rate?
	if not scrape_timer.is_stopped():
		SB.game.scrape_timer_value_changed.emit(scrape_timer.time_left)


## On timeout we compare our penetration power to firewall
func _on_scrape_timer_timeout() -> void:
	var total: float = 0
	var table_entries: Array[Dictionary] = [
		{"item": "penetration", "weight": penetration_power},
		{"item": "firewall", "weight": firewall_strength},
	]

	for loot_entry in table_entries:
		total += loot_entry.weight
	
	var rand = randf() * total
	
	for loot_entry in table_entries:
		if rand < loot_entry.weight:
			if loot_entry.item == "penetration":
				increase_octet()
				_print_chances()
				add_unparsed_data()
			return
		rand -= loot_entry.weight


func increase_octet() -> void:
	fourth_octet += 1
	firewall_strength += _fourth_octet_increase
	
	if fourth_octet > 255:
		fourth_octet = 0
		third_octet += 1
		firewall_strength += _third_octet_increase
	
	if third_octet > 255:
		third_octet = 0
		second_octet += 1
		firewall_strength += _second_octet_increase
	
	if second_octet > 255:
		second_octet = 0
		first_octet += 1
		firewall_strength += _first_octet_increase
	
	if first_octet > 255:
		first_octet = 0
		prestige += 1
		firewall_strength = 1.0
		SB.game.prestige_increased.emit()

	firewall_strength = snappedf(firewall_strength, 0.1)
	SB.game.octet_increased.emit(first_octet, second_octet, third_octet, fourth_octet)


func add_unparsed_data() -> void:
	var total: int = unparsed_data + valued_data + junk_data
	if total < data_storage_size:
		unparsed_data += data_per_scrape
		SB.game.data_values_changed.emit(data_storage_size, unparsed_data, valued_data, junk_data)
	else:
		scrape_timer.stop()


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


func _print_chances():
	var table_entries: Array[Dictionary] = [
		{"item": "penetration", "weight": penetration_power},
		{"item": "firewall", "weight": firewall_strength},
	]
	if table_entries.is_empty():
		assert(false, "No entries in the loot table.")

	var total: float = 0
	for loot_entry in table_entries:
		total += loot_entry.weight

	for loot_entry in table_entries:
		print("%s drop chance is %.2f%%." % [loot_entry.item, loot_entry.weight / total * 100])
