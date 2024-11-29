extends Node
class_name CustomWeaponManager
@onready var torch: Node2D = $Torch

@export var starting_weapon: Weapon

@export var max_unequiped_weapons: int
var unequiped_weapons: Array[Weapon]

var player: Player:
	set(p):
		player = p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_weapon = torch


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func equip_starting_weapon() -> void:
	remove_child(starting_weapon)
	equip_weapon(starting_weapon)


func equip_weapon(weapon: Weapon) -> void:
	player.weapon = weapon
	player.add_child(weapon)


func unequip_weapon(weapon: Weapon) -> void:
	player.remove_child(weapon)


func change_weapon(slot: int, new_weapon: Weapon) -> void:
	if unequiped_weapons.is_empty():
		return
	
	if slot >= max_unequiped_weapons:
		return
	
	unequip_weapon(new_weapon)
	var weapon_to_equip = unequiped_weapons[slot]
	unequiped_weapons[slot] = new_weapon
	equip_weapon(weapon_to_equip)
