package read_json

import "core:encoding/json"
import "core:fmt"

import "core:os"

main :: proc() {
	data, read_err := os.read_entire_file("ressources/main.ldtk", context.allocator)
	if read_err != nil {
		fmt.eprintfln("Failed to load the file: %v", read_err)
	}
	defer delete(data)

	json_data, parse_err := json.parse(data)
	if parse_err != .None {
		fmt.eprintfln("Failed to read json file...")
		fmt.eprintfln("Error: ", parse_err)
		return
	}
	defer json.destroy_value(json_data)

	root := json_data.(json.Object)
	levels := root["levels"].(json.Array)
	level := levels[0].(json.Object)
	fmt.println(level["identifier"])
}
