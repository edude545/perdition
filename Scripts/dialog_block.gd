extends Resource
class_name DialogBlock

@export_multiline var messages: Array[String]
@export_multiline var choices: Array[String]
@export var linked_blocks: Array[DialogBlock]
@export var write_speed_mult: float = 1.0

func length() -> int:
	return messages.size()

func has_choices() -> bool:
	return choices.size() != 0
