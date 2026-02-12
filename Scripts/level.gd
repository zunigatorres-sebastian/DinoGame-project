extends Node2D

enum GameState {INGAME, GAMEOVER}
var state: GameState = GameState.INGAME

var score: int = 0
var highscore: int = 0
const PATH := "user://save.dat"

var speed: float = 120.0
var speed_change: float = 7.0
var next_speed_meter: float = 20.0
var m: int = 0
var mTimer: float = 0.0

var distance_counter: float = 0.0
var spawn_distance: float = randf_range(180.0, 300.0)

var CactusScenes = [
	preload("res://Scenes/large_cactus.tscn"),
	preload("res://Scenes/medium_cactus.tscn"),
	preload("res://Scenes/small_cactus.tscn")]

func _ready() -> void:
	$Player.die.connect(_on_player_died)
	load_highScore()

func load_highScore():
	if FileAccess.file_exists(PATH):
		var file = FileAccess.open(PATH, FileAccess.READ)
		highscore = file.get_var()
		file.close()
	else:
		highscore = 0

func save_highScore():
	var file = FileAccess.open(PATH,FileAccess.WRITE)
	file.store_var(highscore)
	file.close()

func _process(delta: float) -> void:
	if state == GameState.INGAME:
		SpawnCount(delta)
		ParallaxOn(delta)
		MetersTraveled(delta)
	elif state == GameState.GAMEOVER:
		return

func ParallaxOn(delta):
	$Background/Cloud1.scroll_offset.x -= speed * 0.1 * delta
	$Background/Cloud2.scroll_offset.x -= speed * 0.4 * delta
	$Background/Cloud3.scroll_offset.x -= speed * 0.7 * delta
	$Background/Cloud4.scroll_offset.x -= speed * 1.0 * delta

func SpawnObstacles():
	var Cactus = CactusScenes.pick_random().instantiate()
	Cactus.level = self
	Cactus.position = Vector2(575, 255)
	add_child(Cactus)

func SpawnCount(delta):
	distance_counter += speed * delta
	if distance_counter >= spawn_distance:
		SpawnObstacles()
		distance_counter = 0
		spawn_distance = randf_range(180.0, 300.0)

func MetersTraveled(delta):
	mTimer += delta
	if mTimer > 1.0:
		m += 1
		score = m
	$UI.update_meters(score, highscore)
	NextSpeed()

func NextSpeed():
	if speed < 260 && m >= next_speed_meter:
		speed += speed_change
		next_speed_meter += 40

func _on_player_died():
	state = GameState.GAMEOVER
	speed = 0
	if score > highscore:
		highscore = score
		save_highScore()
	$GameOver_Sound/Music.stop()
	$GameOver_Sound.play()
	$UI.show_game_over(score, highscore)
