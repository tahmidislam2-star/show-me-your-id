extends Node2D

@onready var id_name: Label = $CanvasLayer/Id/Name
@onready var department: Label = $CanvasLayer/Id/Department
@onready var id: Label = $CanvasLayer/Id/ID
@onready var blood_group: Label = $"CanvasLayer/Id/Blood Group"
@onready var validity: Label = $CanvasLayer/Id/Validity


@onready var blackout: ColorRect = $CanvasLayer/blackout
@onready var gameover_panel: Panel = $CanvasLayer/blackout/Gameover_panel
@onready var final_label: Label = $CanvasLayer/blackout/Gameover_panel/FinalLabel
@onready var rank: Label = $CanvasLayer/blackout/Gameover_panel/Rank
@onready var play_again: Button = $CanvasLayer/blackout/Gameover_panel/PlayAgain
@onready var main_menu: Button = $CanvasLayer/blackout/Gameover_panel/Main_Menu

@onready var female_button: Button = $CanvasLayer/Female_Button
@onready var male_button: Button = $CanvasLayer/Male_button
@onready var male: Control = $CanvasLayer/Male
@onready var female: Control = $CanvasLayer/Female

@onready var hair: Sprite2D = $Character/Hair
@onready var eyes: Sprite2D = $Character/Eyes
@onready var nose: Sprite2D = $Character/Nose
@onready var mouth: Sprite2D = $Character/Mouth
@onready var cloth: Sprite2D = $Character/Cloth

@onready var mhair: Control = $CanvasLayer/Male/Hair
@onready var mnose: Control = $CanvasLayer/Male/Nose
@onready var meyes: Control = $CanvasLayer/Male/Eyes
@onready var mlips: Control = $CanvasLayer/Male/Lips

@onready var fhair: Control = $CanvasLayer/Female/Hair
@onready var fnose: Control = $CanvasLayer/Female/Nose
@onready var feyes: Control = $CanvasLayer/Female/Eyes
@onready var flips: Control = $CanvasLayer/Female/Lips

@onready var texture_button: TextureButton = $CanvasLayer/TextureButton
@onready var feature_warning: Label = $CanvasLayer/FeatureWarning
@onready var hearts: GridContainer = $CanvasLayer/hearts

@onready var guard: Sprite2D = $Guard
@onready var guard_feedback: ColorRect = $CanvasLayer/GuardFeedback
@onready var guard_label: Label = $CanvasLayer/GuardLabel

const FEATURES := ["hair", "eyes", "nose", "mouth"]
const TYPE_SPEED := 0.08 
const SHAKE_HEIGHT := 4.0 
const SHAKE_TIME := 0.08
const HOLD_TIME := 1.0 

const HEART_SHAKE := 5.0
const HEART_SHAKE_TIME := 0.04
const HEART_DROP_DISTANCE := 80.0
const HEART_DROP_TIME := 0.45

const BLACKOUT_FADE_TIME := 1.5
const PANEL_FADE_TIME := 0.5
const POP_TIME := 0.35
const POP_STAGGER := 0.15

const RANKS := [
	"Master Impostor",
	"Phantom",
	"Smooth Operator",
	"Con Artist",
	"Silver Tongue",
	"Suspicious Character",
	"Amateur Faker",
	"Bad Liar",
	"Busted",
]

const START_LINES := ["Show me your id."]
const WRONG_LINES := [
	"Are you sure that's you?",
	"That doesn't look right.",
	"Hmm... this photo doesn't match.",
	"Do you think I'm stupid?",
	"That's not what's on the id.",
	"Something's off about your face.",
	"Hold on... that's not you.",
	"That photo looks suspiciously different.",
	"Why do you look so different?",
	"I can't quite put my finger on it.",
	"I'm not convinced.",
	"Did you make this yourself?",
	"That's the best photo you could find?",
	"Nice Photoshop job.",
	"Did you borrow this from someone?",
	"Points for confidence, I suppose.",
	"I'm supposed to believe this?",
	"Don't play games with me.",
	"I need some answers.",
	"Stop wasting my time.",
	"Step aside for a moment.",
	"I need a moment with this one.",
	"Am I seeing this wrong?",
	"That is... unusual.",
	"Don't make me call my supervisor.",
	"You really think I won't notice?",
	"Care to explain before I make a call?",
	"Come back with a real ID.",
	"Nice try."
]
const MALE_NAMES := [
	"Md Abdullah Al Mamun",
	"Mohammad Ashraful Islam",
	"Abdullah Al Mahmud",
	"Shahriar Ahmed Chowdhury",
	"Fahim Hasan Mahmud",
	"Tanvir Ahmed Hossain",
	"Mehedi Hasan Rahman",
	"Shahriar Kabir Ahmed",
	"Mohammad Ariful Islam",
	"Mahmudul Hasan Chowdhury",
	"Abu Sayeed Mahmud",
	"Syed Mahbubur Rahman",
	"Farhan Ahmed Chowdhury",
	"Rakibul Hasan Ahmed",
	"Imran Hossain Chowdhury",
	"Faisal Ahmed Mahmud",
	"Zubair Hasan Chowdhury",
	"Shakib Al Hasan Rahman",
	"Raihan Kabir Mahmud",
	"Adnan Ahmed Chowdhury",
	"Abdur Rahman Siddiqui",
	"Mustafizur Rahman Khan",
	"Nasir Uddin Mahmud",
	"Mahfuzur Rahman Ahmed",
	"Anik Hasan Chowdhury",
	"Sabbir Ahmed Hossain",
	"Tamim Iqbal Chowdhury",
	"Rafsan Ahmed Mahmud",
	"Saifuddin Ahmed Rahman",
	"Munirul Islam Chowdhury"
]

const FEMALE_NAMES := [
	"Nusrat Jahan Chowdhury",
	"Samia Afrin Mahmud",
	"Fatema Tuz Zahra Khan",
	"Sumaiya Akter Rahman",
	"Sharmin Sultana Ahmed",
	"Farzana Yasmin Chowdhury",
	"Mehnaz Tabassum Rahman",
	"Jannatul Ferdous Ahmed",
	"Mahjabin Akter Chowdhury",
	"Sadika Tasnim Mahmud",
	"Sharmeen Akter Hossain",
	"Anika Tabassum Chowdhury",
	"Fariha Ahmed Siddiqui",
	"Rumana Yasmin Mahmud",
	"Afroza Sultana Chowdhury",
	"Rafia Jahan Mahmud",
	"Israt Jahan Chowdhury",
	"Shanjida Akter Rahman",
	"Lamisa Tasnim Ahmed",
	"Sumaiya Jannat Hossain",
	"Nafisa Tabassum Rahman",
	"Bushra Ahmed Chowdhury",
	"Arifa Sultana Mahmud",
	"Sharifa Akter Hossain",
	"Mehnur Jahan Chowdhury",
	"Sadmanara Yasmin Ahmed",
	"Sanjida Afrin Mahmud",
	"Mahmuda Khatun Chowdhury",
	"Farhana Akter Siddiqui",
	"Jannatul Mawa Rahman"
]

const BRACU_DEGREES := [
	"Bachelor of Computer Science",
	"Bachelor of Computer Science and Engineering",
	"Bachelor of Electrical and Electronic Engineering",
	"Bachelor of Electronic and Communication Engineering",
	"Bachelor of Computer Engineering",
	"Bachelor of Electrical and Electronic Engineering",
	"Bachelor of Business Administration",
	"Bachelor of Economics",
	"Bachelor of English",
	"Bachelor of Arts in English",
	"Bachelor of Pharmacy",
	"Bachelor of Architecture",
	"Bachelor of Science in Physics",
	"Bachelor of Science in Applied Physics and Electronics",
	"Bachelor of Science in Biotechnology",
	"Bachelor of Science in Microbiology",
	"Bachelor of Science in Mathematics",
	"Bachelor of Science in Environmental Science",
	"Bachelor of Science in Applied Physics",
	"Bachelor of Science in Computer Science",
	"Bachelor of Science in Computer Science and Engineering",
	"Bachelor of Science in Electrical and Electronic Engineering",
	"Bachelor of Science in Electronic and Communication Engineering",
	"Bachelor of Science in Computer Engineering",
	"Bachelor of Science in Economics",
	"Bachelor of Science in Applied Mathematics",
	"Bachelor of Social Science in Anthropology",
	"Bachelor of Social Science in Sociology",
	"Bachelor of Development Studies",
	"Bachelor of Laws",
	"Bachelor of Education",
	"Bachelor of Fine Arts"
]

const BLOOD_TYPES := [
	"A+",
	"A-",
	"B+",
	"B-",
	"AB+",
	"AB-",
	"O+",
	"O-"
]

const CORRECT_LINES := [
	"Alright, you're good.",
	"Everything checks out.",
	"You're all set. Go ahead.",
	"Looks good to me.",
	"Welcome in.",
	"Alright, move along.",
	"You're clear to enter.",
	"Go right ahead.",
	"You're good to go.",
	"Everything seems fine.",
	"That checks out.",
	"You're good. Next!",
	"That looks right.",
	"Welcome. Don't cause any trouble.",
	"Okay, you're in.",
	"You're clear. Keep moving.",
	"Seems legit.",
	"That's what I like to see.",
	"Finally, someone with proper ID.",
	"Everything looks normal.",
	"Okay, I believe you.",
	"You're good. Don't lose that ID.",
	"Looks like everything's in order.",
	"Okay, no reason to stop you.",
	"Go ahead. Have a good one.",
	"You're clear. Next person!",
	"Fine by me. Go ahead.",
	"Everything checks out. Enjoy.",
	"You're good. Keep it moving.",
	"Okay, you're officially cleared.",
	"Right, you're free to enter."
]
const GAME_OVER_LINES := [
	"That's it. You're not getting in.",
	"Get out.",
	"Get out before I call the police.",
	"I said get out!",
	"I'm calling the police.",
	"Yes, hello? There's a fake id at my door.",
]

var sprites: Dictionary
var groups: Dictionary 
var all_buttons: Array[BaseButton] = [] 

var target := {}
var guess := {} 

var lives := 0
var max_lives := 0
var game_over := false
var transitioning := false
var type_tween: Tween

var guard_base_y := 0.0
var talking := false
var shake_tween: Tween
var wrong_pool: Array = []
var correct_pool: Array = []

var blackout_alpha := 1.0


func _ready() -> void:
	sprites = {"hair": hair, "eyes": eyes, "nose": nose, "mouth": mouth}
	groups = {
		"male": {"hair": mhair, "eyes": meyes, "nose": mnose, "mouth": mlips},
		"female": {"hair": fhair, "eyes": feyes, "nose": fnose, "mouth": flips},
	}

	for gender in groups:
		for feature in FEATURES:
			for btn in _buttons_of(groups[gender][feature]):
				btn.pressed.connect(_on_option_pressed.bind(gender, feature, btn))
				all_buttons.append(btn)

	male_button.pressed.connect(_on_gender_pressed.bind("male"))
	female_button.pressed.connect(_on_gender_pressed.bind("female"))
	texture_button.pressed.connect(_on_submit_pressed)
	all_buttons.append_array([male_button, female_button, texture_button])

	play_again.pressed.connect(_on_play_again_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)

	blackout_alpha = blackout.color.a if blackout.color.a > 0.0 else 1.0
	blackout.visible = false
	gameover_panel.visible = false

	max_lives = hearts.get_child_count()
	guard_base_y = guard.position.y
	guard_feedback.visible = false
	guard_label.visible = false

	_new_round()
	_guard_talk(START_LINES)


func _new_round() -> void:
	game_over = false
	lives = max_lives
	feature_warning.text = ""

	for heart in hearts.get_children():
		if heart is Control:
			heart.top_level = false
			heart.visible = true
			heart.modulate.a = 1.0
	hearts.queue_sort()

	_pick_target()
	_randomize_id()
	_randomize_cloth()
	_randomize_cloth()
	guess = {"gender": ""}
	_reset_guess()
	_on_gender_pressed("male")


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

func _reset_guess() -> void:
	guess = {"gender": guess.get("gender", "")}
	for feature in FEATURES:
		guess[feature] = 0
		sprites[feature].texture = null
	for gender in groups:
		for feature in FEATURES:
			for btn in _buttons_of(groups[gender][feature]):
				btn.disabled = false

func _set_input_locked(locked: bool) -> void:
	var filter := Control.MOUSE_FILTER_IGNORE if locked else Control.MOUSE_FILTER_STOP
	for btn in all_buttons:
		btn.mouse_filter = filter

func _on_gender_pressed(gender: String) -> void:
	if game_over or talking:
		return
	var is_male := gender == "male"
	male_button.disabled = is_male
	female_button.disabled = not is_male
	male.visible = is_male
	female.visible = not is_male
	if guess.get("gender", "") != gender:
		guess["gender"] = gender
		_reset_guess()


func _on_option_pressed(gender: String, feature: String, pressed_btn: Button) -> void:
	if game_over or talking or gender != guess["gender"]:
		return
	for btn in _buttons_of(groups[gender][feature]):
		btn.disabled = (btn == pressed_btn)
	var icon_rect := pressed_btn.get_node("TextureRect") as TextureRect
	sprites[feature].texture = icon_rect.texture
	guess[feature] = int(str(pressed_btn.name))

func _on_submit_pressed() -> void:
	if game_over or talking:
		return
	for feature in FEATURES:
		if guess[feature] == 0:
			_type_text("All features are not selected.")
			return

	var wrong := 0
	if guess["gender"] != target["gender"]:
		wrong += 1
	for feature in FEATURES:
		if guess["gender"] != target["gender"] or guess[feature] != target[feature]:
			wrong += 1

	if wrong == 0:
		game_over = true
		_type_text("Bingo!")
		await _guard_talk([_draw_line(correct_pool, CORRECT_LINES)])
		_show_gameover(true)
		return

	var noun := "Feature is" if wrong == 1 else "Features are"
	_type_text("%d %s Wrong." % [wrong, noun])
	_lose_heart()


func _lose_heart() -> void:
	if game_over:
		return

	lives -= 1

	if lives >= 0 and lives < hearts.get_child_count():
		_drop_heart(hearts.get_child(lives) as Control)

	if lives <= 0:
		game_over = true
		await _guard_talk([GAME_OVER_LINES.pick_random()])
		_show_gameover(false)
	else:
		_guard_talk([_draw_line(wrong_pool, WRONG_LINES)])
		
func _drop_heart(heart: Control) -> void:
	if heart == null:
		return
	var start := heart.global_position
	heart.top_level = true
	heart.global_position = start

	var tw := create_tween()
	for i in 4:
		var offset := HEART_SHAKE if i % 2 == 0 else -HEART_SHAKE
		tw.tween_property(heart, "global_position:x", start.x + offset, HEART_SHAKE_TIME)
	tw.tween_property(heart, "global_position:x", start.x, HEART_SHAKE_TIME)
	tw.tween_property(heart, "global_position:y", start.y + HEART_DROP_DISTANCE, HEART_DROP_TIME) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.parallel().tween_property(heart, "modulate:a", 0.0, HEART_DROP_TIME)
	tw.tween_callback(heart.hide)

func _draw_line(pool: Array, source: Array) -> String:
	if pool.is_empty():
		pool.append_array(source)
		pool.shuffle()
	return pool.pop_back()

func _guard_talk(lines: Array) -> void:
	if talking:
		return

	talking = true
	_set_input_locked(true)
	guard_feedback.visible = true
	guard_label.visible = true
	_start_shake()

	for line in lines:
		await _say(line)

	_stop_shake()
	guard_feedback.visible = false
	guard_label.visible = false
	_set_input_locked(false)
	talking = false


func _say(msg: String) -> void:
	guard_label.text = msg
	guard_label.visible_ratio = 0.0
	var t := create_tween()
	t.tween_property(guard_label, "visible_ratio", 1.0, msg.length() * TYPE_SPEED)
	await t.finished
	await get_tree().create_timer(HOLD_TIME).timeout


func _start_shake() -> void:
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
	shake_tween = create_tween().set_loops()
	shake_tween.tween_property(guard, "position:y", guard_base_y - SHAKE_HEIGHT, SHAKE_TIME)
	shake_tween.tween_property(guard, "position:y", guard_base_y, SHAKE_TIME)


func _stop_shake() -> void:
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
	guard.position.y = guard_base_y


func _type_text(msg: String) -> void:
	if type_tween and type_tween.is_valid():
		type_tween.kill()
	feature_warning.text = msg
	feature_warning.visible_ratio = 0.0
	type_tween = create_tween()
	type_tween.tween_property(feature_warning, "visible_ratio", 1.0, msg.length() * TYPE_SPEED)
	
func _show_gameover(won: bool) -> void:
	final_label.text = "Well done" if won else "Game over"

	var hearts_lost := clampi(max_lives - lives, 0, RANKS.size() - 1)
	rank.text = "Rank: " + RANKS[hearts_lost]
	rank.visible_ratio = 0.0

	play_again.visible = false
	main_menu.visible = false
	gameover_panel.visible = false
	blackout.color.a = 0.0
	blackout.visible = true
	var fade := create_tween()
	fade.tween_property(blackout, "color:a", blackout_alpha, BLACKOUT_FADE_TIME)
	await fade.finished

	gameover_panel.modulate.a = 0.0
	gameover_panel.visible = true
	var reveal := create_tween()
	reveal.tween_property(gameover_panel, "modulate:a", 1.0, PANEL_FADE_TIME)
	await reveal.finished

	var typing := create_tween()
	typing.tween_property(rank, "visible_ratio", 1.0, rank.text.length() * TYPE_SPEED)
	await typing.finished

	_pop(play_again)
	await get_tree().create_timer(POP_STAGGER).timeout
	_pop(main_menu)


func _pop(ctrl: Control) -> void:
	ctrl.pivot_offset = ctrl.size / 2.0
	ctrl.scale = Vector2.ZERO
	ctrl.visible = true
	var tw := create_tween()
	tw.tween_property(ctrl, "scale", Vector2.ONE, POP_TIME) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
func _randomize_id() -> void:
	var names: Array = MALE_NAMES if target["gender"] == "male" else FEMALE_NAMES
	id_name.text = names.pick_random()
	department.text = BRACU_DEGREES.pick_random()
	id.text = "Student ID: %d" % randi_range(10000000, 99999999)
	blood_group.text = "Blood group: " + BLOOD_TYPES.pick_random()

	var start := Time.get_unix_time_from_datetime_string("2026-01-01T00:00:00")
	var end := Time.get_unix_time_from_datetime_string("2028-12-31T00:00:00")
	var date := Time.get_date_dict_from_unix_time(randi_range(start, end))
	validity.text = "Validity: %02d/%02d/%d" % [date.day, date.month, date.year]

func _on_play_again_pressed() -> void:
	if transitioning:
		return
	transitioning = true

	gameover_panel.visible = false
	_new_round()

	var fade := create_tween()
	fade.tween_property(blackout, "color:a", 0.0, BLACKOUT_FADE_TIME)
	await fade.finished
	blackout.visible = false

	transitioning = false
	_guard_talk(START_LINES)


func _on_main_menu_pressed() -> void:
	pass # TODO: main menu
