extends Node


var first_octet: int = 0
var second_octet: int = 0
var third_octet: int = 0
var fourth_octet: int = 0

var scrape_time: float = 20.0 ## Time to scrape one fourth octet
var unparsed_data: int = 0 ## Unparsed data that's been downloaded
var unparsed_data_max: int = 10 ## Maxium data storage for unparsed data

var parsed_data: int = 0 ## Data that was successfully parsed
var junk_data: int = 0 ## Data that failed to parse

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
		"unparsed_data": {
			"value": unparsed_data,
			"max": unparsed_data_max,
		},
		"parsed_data": {
			"value": parsed_data,
			"junk": junk_data,
		},
		"prestige": prestige,
	}
	return true
