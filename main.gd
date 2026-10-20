extends Node2D

# --- Gender ---
@onready var female_button: Button = $CanvasLayer/Female_Button
@onready var male_button: Button = $CanvasLayer/Male_button
@onready var male: Control = $CanvasLayer/Male
@onready var female: Control = $CanvasLayer/Female

# --- Character sprites (what the player is building) ---
@onready var hair: Sprite2D = $Character/Hair
@onready var eyes: Sprite2D = $Character/Eyes
@onready var nose: Sprite2D = $Character/Nose
@onready var mouth: Sprite2D = $Character/Mouth
@onready var cloth: Sprite2D = $Character/Cloth

# --- Male option groups ---
@onready var mhair: Control = $CanvasLayer/Male/Hair
@onready var mnose: Control = $CanvasLayer/Male/Nose
@onready var meyes: Control = $CanvasLayer/Male/Eyes
@onready var mlips: Control = $CanvasLayer/Male/Lips

# --- Female option groups ---
@onready var fhair: Control = $CanvasLayer/Female/Hair
@onready var fnose: Control = $CanvasLayer/Female/Nose
@onready var feyes: Control = $CanvasLayer/Female/Eyes
@onready var flips: Control = $CanvasLayer/Female/Lips

# --- Feedback ---
@onready var texture_button: TextureButton = $CanvasLayer/TextureButton
@onready var feature_warning: Label = $CanvasLayer/FeatureWarning
@onready var hearts: HBoxContainer = $CanvasLayer/hearts

const FEATURES := ["hair", "eyes", "nose", "mouth"]
const TYPE_SPEED := 0.04 # seconds per character

var sprites: Dictionary
var groups: Dictionary # gender -> feature -> Control

var target := {}  # gender: "male"/"female", hair/eyes/nose/mouth: 1..5
var guess := {}   # same shape; gender "" and features 0 mean "not picked yet"

var lives := 0
var game_over := false
var type_tween: Tween


func _ready() -> void:
	sprites = {"hair": hair, "eyes": eyes, "nose": nose, "mouth": mouth}
	groups = {
		"male": {"hair": mhair, "eyes": meyes, "nose": mnose, "mouth": mlips},
		"female": {"hair": fhair, "eyes": feyes, "nose": fnose, "mouth": flips},
	}

	# Wire up every option button (named "1".."5") in every group.
	for gender in groups:
		for feature in FEATURES:
			for btn in _buttons_of(groups[gender][feature]):
				btn.pressed.connect(_on_option_pressed.bind(gender, feature, btn))

	male_button.pressed.connect(_on_gender_pressed.bind("male"))
	female_button.pressed.connect(_on_gender_pressed.bind("female"))
	texture_button.pressed.connect(_on_submit_pressed)

	lives = hearts.get_child_count()
	feature_warning.text = ""

	_pick_target()
	_randomize_cloth()
	_reset_guess()
	_on_gender_pressed("male") # male is selected by default


# ---------- Setup helpers ----------

func _pick_target() -> void:
	target = {"gender": ["male", "female"].pick_random()}
	for feature in FEATURES:
		target[feature] = randi_range(1, 5)
	print("Target (debug): ", target)


func _randomize_cloth() -> void:
	cloth.modulate = Color.from_hsv(randf(), randf_range(0.4, 0.8), randf_range(0.6, 1.0))


func _buttons_of(group: Control) -> Array[Button]:
	var result: Array[Button] = []
	for child in group.get_children():
		if child is Button:
			result.append(child)
	return result


# Clears hair/eyes/nose/mouth, re-enables every option button, forgets picks.
func _reset_guess() -> void:
	guess = {"gender": guess.get("gender", "")}
	for feature in FEATURES:
		guess[feature] = 0
		sprites[feature].texture = null
	for gender in groups:
		for feature in FEATURES:
			for btn in _buttons_of(groups[gender][feature]):
				btn.disabled = false


# ---------- Input ----------

func _on_gender_pressed(gender: String) -> void:
	if game_over:
		return
	var is_male := gender == "male"
	male_button.disabled = is_male
	female_button.disabled = not is_male
	male.visible = is_male
	female.visible = not is_male

	# Switching gender wipes the current look so male/female parts can't mix.
	if guess.get("gender", "") != gender:
		guess["gender"] = gender
		_reset_guess()


func _on_option_pressed(gender: String, feature: String, pressed_btn: Button) -> void:
	if game_over or gender != guess["gender"]:
		return
	# Only the pressed button stays disabled within its group.
	for btn in _buttons_of(groups[gender][feature]):
		btn.disabled = (btn == pressed_btn)

	# Use the same texture the button displays, so the sprite always matches its icon.
	var icon_rect := pressed_btn.get_node("TextureRect") as TextureRect
	sprites[feature].texture = icon_rect.texture
	guess[feature] = int(str(pressed_btn.name))


# ---------- Submit / feedback ----------

func _on_submit_pressed() -> void:
	if game_over:
		return

	var wrong := 0
	if guess["gender"] != target["gender"]:
		wrong += 1
	for feature in FEATURES:
		# A feature only counts as correct if gender AND option index both match.
		if guess["gender"] != target["gender"] or guess[feature] != target[feature]:
			wrong += 1

	if wrong == 0:
		_type_text("Bingo!")
		return

	var noun := "Feature is" if wrong == 1 else "Features are"
	_type_text("%d %s Wrong." % [wrong, noun])
	_lose_heart()


func _lose_heart() -> void:
	lives -= 1
	if lives >= 0 and lives < hearts.get_child_count():
		hearts.get_child(lives).visible = false
	if lives <= 0:
		game_over = true
		# TODO: show game over panel


func _type_text(msg: String) -> void:
	if type_tween and type_tween.is_valid():
		type_tween.kill()
	feature_warning.text = msg
	feature_warning.visible_ratio = 0.0
	type_tween = create_tween()
	type_tween.tween_property(feature_warning, "visible_ratio", 1.0, msg.length() * TYPE_SPEED)
