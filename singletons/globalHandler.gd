tool
extends Node


export var min_global_light : float = 0.010
export var bloodstainsMainHall : bool = false
export var global_light : float = 0.05
var left_arm : bool = true
var do_static_effect : bool = false
var lantern_fuel : float = -1 
var lantern_toggled : bool = false
var current_light : float = global_light
var current_static : float = 0.0
