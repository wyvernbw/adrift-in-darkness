extends Node

"""
Stores Info. about the current state of the player
(limbs left, blood loss) and interacts with other 
scripts.
"""

signal playerDied

const maxBlood = 4500
const bloodLossRate = 1
const totalLimbs = 4

var blood = maxBlood
var currentLimbs : Dictionary = {
	'rightArm' : true,
	'leftArm' : true,
	'rightLeg' : true,
	'leftLeg' : true
}

var bleedingLimbs : Dictionary = {
	'rightArm' : false,
	'leftArm' : false,
	'rightLeg' : false,
	'leftLeg' : false
}

func _process(delta: float) -> void:
	calculateBloodLoss()

#Damage Player
func cutLimb(limb : String):
	if limb == null:
		return
	_removeLimb(limb)
	_setLimbBleeding(limb)

func _removeLimb(limb : String) -> void : 
	if limb == null:
		return
	if currentLimbs[limb] == null:
		return
	
	currentLimbs[limb] = false

func _setLimbBleeding(limb : String) -> void:
	if limb == null:
		return
	if bleedingLimbs[limb] == null:
		return
		
	bleedingLimbs[limb] = true

#Heal Player
func stopLimbBleeding(limb : String) -> void:
	if limb == null:
		return
	if bleedingLimbs[limb] == null:
		return
		
	bleedingLimbs[limb] = false

func resetBlood() -> void:
	blood = maxBlood

func resetLimbs() -> void:
	var possibleLimbs : Array = currentLimbs.keys()
	for i in totalLimbs:
		currentLimbs[possibleLimbs[i]] = true
		bleedingLimbs[possibleLimbs[i]] = false
		
#Apply blood loss logic
func calculateBloodLoss() -> void:
	if blood == 0:
		emit_signal("playerDied")
		return
	
	var possibleLimbs : Array = currentLimbs.keys()
	var bleedingLimbsCount : int
	
	for iter in totalLimbs :
		if bleedingLimbs[possibleLimbs[iter]] == true:
			bleedingLimbsCount += 1
			
	if bleedingLimbsCount == 0:
		return
			
	blood -= bloodLossRate * bleedingLimbsCount
	print(blood)
