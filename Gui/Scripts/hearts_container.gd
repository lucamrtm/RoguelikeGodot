extends HBoxContainer

const HEART_GUI = preload("res://Gui/heart_gui.tscn")

var player_health: HealthComponent:
	set(health):
		player_health = health
		setMaxHearts(player_health.maxHealth)
		updateHearts(player_health.currentHealth)

func setMaxHearts(maxHealthChange):
	while maxHealthChange > 0:
		var heart = HEART_GUI.instantiate()
		add_child(heart)
		maxHealthChange -= 1
	while maxHealthChange < 0:
		get_children()[-1].queue_free()
		maxHealthChange += 1


func updateHearts(healthChange: int):
	var hearts = get_children()
	
	for i in range(player_health.currentHealth):
		hearts[i].update(true)
	
	for i in range(player_health.currentHealth, hearts.size()):
		hearts[i].update(false)
