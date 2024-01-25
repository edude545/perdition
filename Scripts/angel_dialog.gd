extends Control

@onready var label = $Panel/Label
@onready var button_container = $ButtonContainer

@export var start_dialog_block: DialogBlock

@export var write_speed: float = 1.0
@export var newline_pause: float = 12.0
@export var long_pause: float = 4.0
@export var short_pause: float = 2.5

var typing: bool
var timer: float
var timer_threshold: float
var msg: String
var dialog_block: DialogBlock
var block_index: int
var shown_choices: bool

var long_pause_characters = [".", "?", "!", ":"]
var short_pause_characters = [",", ";"]

@onready var button = preload("res://Scenes/dialog_button.tscn")

func _ready():
	typing = false
	timer = 0.0
	timer_threshold = 1.0
	dialog_block = start_dialog_block
	block_index = 0
	shown_choices = false
	start_message()
	
func _process(delta):
	if typing:
		timer += write_speed * delta
		if timer > timer_threshold:
			timer -= timer_threshold
			label.visible_characters += 1
			var chr = msg[label.visible_characters-1]
			timer_threshold = (newline_pause if chr=="\n" else long_pause if long_pause_characters.has(chr) else short_pause if short_pause_characters.has(chr) else 1.0)
			if label.visible_characters == msg.length():
				on_finished_typing()

func start_message():
	msg = dialog_block.messages[block_index]
	typing = true
	timer = 0.0
	timer_threshold = 1.0
	label.visible_characters = 0
	label.text = msg

func skip_message():
	print("Skipping")
	label.visible_characters = msg.length()
	on_finished_typing()

func on_finished_typing():
	typing = false
	timer = 0.0
			
func display_choices():
	shown_choices = true
	for index in dialog_block.choices.size():
		var btn = button.instantiate()
		btn.get_node("Button").button_down.connect(func():return on_choice_clicked(index))
		btn.get_node("Label").text = dialog_block.choices[index]
		button_container.add_child(btn)

func on_choice_clicked(index: int):
	dialog_block = dialog_block.linked_blocks[index]
	start_message()
	for btn in button_container.get_children():
		btn.queue_free()
	shown_choices = false

func next():
	print("Next")
	block_index += 1
	if block_index == dialog_block.length():
		block_index = 0
		if dialog_block.has_choices():
			display_choices()
		else:
			dialog_block = dialog_block.linked_blocks[0]
			start_message()
	else:
		start_message()

func _on_gui_input(ev):
	if ev is InputEventMouseButton and ev.pressed:
		if shown_choices: return
		if typing:
			skip_message()
		else:
			next()
