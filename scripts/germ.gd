extends PathFollow2D

@export var variance = 10
var timeAlive = 0
var maxColor = 100.0
var currentHealth
var alive = true

@onready var germController = get_parent()

#dictionary with genome
var genome = {"Speed": 50.0, "Color": 100, "Health": 10}

# Called when the node enters the scene tree for the first time.
func _ready():
	mutate()
	currentHealth = genome["Health"]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(currentHealth <= 0):
		germPop()
		return
		
	timeAlive += 1
		
	global_rotation = 0 #no option to move along a path without rotating otherwise

	#update brightness to reflect health
	modulate = Color.from_hsv(genome["Color"] / float(maxColor), 1, currentHealth / float(genome["Health"])) 
	
func germPop():
	if(alive):
		position = Vector2(-1000, -1000)
		germController.numPopped += 1
		alive = false
		
func mutate():
	for gene in genome:
		genome[gene] += randi_range(-variance, variance)
		
		#set value to positive, with min of 1
		genome[gene] = abs(genome[gene]) + 1
		
func checkGenes(speedLimit, healthLimit):
	#cap genes
	if(genome["Speed"] > speedLimit):
		genome["Speed"] = speedLimit
		
	if(genome["Health"] > healthLimit):
		genome["Health"] = healthLimit
