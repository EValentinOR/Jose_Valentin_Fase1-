extends Control

@export var card_scene: PackedScene
@export var card_images: Array[Texture2D] = []

@onready var grid_container: GridContainer = $GridContainer

var flipped_cards: Array[Card] = []
var pairs_found: int = 0
var total_pairs: int = 8
var is_processing: bool = false

func _ready() -> void:
	start_game()

func start_game() -> void:
	pairs_found = 0
	flipped_cards.clear()
	is_processing = false
	
	for child in grid_container.get_children():
		child.queue_free()
		
	var deck_data: Array[Dictionary] = []
	
	for id in range(min(total_pairs, card_images.size())):
		var tex = card_images[id]
		deck_data.append({"id": id, "texture": tex})
		deck_data.append({"id": id, "texture": tex})
	
	deck_data.shuffle()
	
	for item in deck_data:
		var new_card = card_scene.instantiate() as Card
		grid_container.add_child(new_card)
		new_card.setup(item.id, item.texture)
		new_card.card_clicked.connect(_on_card_clicked)

func _on_card_clicked(card: Card) -> void:
	if is_processing or card.is_flipped:
		return
		
	card.flip()
	flipped_cards.append(card)
	
	if flipped_cards.size() == 2:
		_check_match()

func _check_match() -> void:
	is_processing = true
	var card1 = flipped_cards[0]
	var card2 = flipped_cards[1]
	
	if card1.card_id == card2.card_id:
		card1.set_matched()
		card2.set_matched()
		pairs_found += 1
		flipped_cards.clear()
		is_processing = false
		
		if pairs_found == total_pairs:
			print("¡Has ganado el juego!")
	else:
		await get_tree().create_timer(0.6).timeout
		card1.show_back()
		card2.show_back()
		flipped_cards.clear()
		is_processing = false
