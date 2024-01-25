extends Control

@onready var label = $Label
@onready var button_container = $ButtonContainer

@export var start_dialog_block: DialogBlock

@export var write_speed: float = 1.0
@export var long_pause: float = 4.0
@export var short_pause: float = 2.5

var typing: bool
var timer: float
var timer_threshold: float
var msg: String
var dialog_block: DialogBlock
var block_index: int

var long_pause_characters = [".", "?", "!", ":"]
var short_pause_characters = [",", ";"]

@onready var button = preload("res://Scenes/dialog_button.tscn")

func _ready():
	typing = false
	timer = 0.0
	timer_threshold = 1.0
	dialog_block = start_dialog_block
	block_index = 0
	start_message(dialog_block.messages[0])
	
func _process(delta):
	if typing:
		timer += write_speed * delta
		if timer > timer_threshold:
			timer -= timer_threshold
			label.visible_characters += 1
			var chr = msg[label.visible_characters-1]
			timer_threshold = (long_pause if long_pause_characters.has(chr) else short_pause if short_pause_characters.has(chr) else 1.0)
			if label.visible_characters == msg.length():
				on_finished_typing()

func start_message(new_msg : String):
	msg = new_msg
	typing = true
	timer = 0.0
	timer_threshold = 1.0
	label.visible_characters = 0
	label.text = msg

func skip_message():
	label.visible_characters = msg.length()
	on_finished_typing()

func on_finished_typing():
	typing = false
	timer = 0.0
	block_index += 1
	if block_index == dialog_block.length():
		block_index = 0
		if dialog_block.has_choices():
			display_choices()
		else:
			dialog_block = dialog_block.linked_blocks[0]
			
func display_choices():
	for choice in dialog_block.choices:
		var btn = button.instantiate()
		btn.reparent(button_container, false)

func next():
	pass

func _on_gui_input(ev: InputEvent):
	if ev is InputEventMouseButton and ev.pressed:
		if typing:
			skip_message()
		else:
			next()
