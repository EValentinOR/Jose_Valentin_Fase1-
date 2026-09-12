extends TextureButton
class_name Card

signal card_clicked(card: Card)

@onready var front_texture: TextureRect = $Front
@onready var back_texture: TextureRect = $Back

var card_id: int = -1
var is_flipped: bool = false
var is_matched: bool = false

func _ready() -> void:
	pressed.connect(_on_pressed)
	show_back()

func setup(id: int, image_texture: Texture2D) -> void:
	card_id = id
	front_texture.texture = image_texture
	show_back()

func _on_pressed() -> void:
	if is_flipped or is_matched:
		return
	card_clicked.emit(self)

func flip() -> void:
	is_flipped = true
	front_texture.visible = true
	back_texture.visible = false

func show_back() -> void:
	is_flipped = false
	front_texture.visible = false
	back_texture.visible = true

func set_matched() -> void:
	is_matched = true
	disabled = true
