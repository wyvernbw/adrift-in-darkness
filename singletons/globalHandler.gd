tool
extends Node

export var min_global_light: float = 0.005
export var bloodstainsMainHall: bool = false
export var global_light: float = 0.1
export var captions_enabled: bool = true
export var captions_duration: float = 1.5  # seconds

var left_arm: bool = true
var do_static_effect: bool = true
var lantern_fuel: float = -1
var lantern_toggled: bool = false
var lantern_ran_out: bool = false
var current_light: float = global_light
var current_static: float = 0.0
var Player: KinematicBody2D
var InventoryGUI
