extends CanvasLayer

func update_meters(score, highscore):
	$HUD/ScoreContainer/ScoreLabel.text = "Score: " + str(score)
	$HUD/ScoreContainer/HighScoreLabel.text = "HighScore: " + str(highscore)

func show_game_over(score, highscore):
	$HUD.visible = false
	$GameOverPanel.visible = true
	$GameOverPanel/CenterContainer/VBoxContainer/ScoreLabel.text = "Score: " + str(score)
	$GameOverPanel/CenterContainer/VBoxContainer/HighScoreLabel.text = "HighScore: " + str(highscore)
	$GameOverPanel/CenterContainer/VBoxContainer/Button.grab_focus()

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
