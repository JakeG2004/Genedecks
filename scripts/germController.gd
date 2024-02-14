extends Path2D

@export var level = 1
@export var frequency = 5
var numPopped = 0
var germs = []
var germBuffer = []
var germ

var numGerms = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	germ = preload("res://scenes/germ.tscn")
	addGerms()

func addGerms():
	numGerms = 10
	
	#make new germ and add it as a child
	for x in numGerms:
		var tmp = germ.instantiate()
		add_child(tmp)
		germs.append(tmp)
		await get_tree().create_timer(frequency).timeout
	
func mutateGerms():
	#mutate all the children
	for child in get_children():
		child.mutate()
		child.checkGenes(25, 10) #TODO: Replace magic numbers

func _process(delta):
	moveBalloons(delta)
	
	if(numPopped == numGerms):
		nextWave()
		
func nextWave():
	print("new wave")
	numPopped = 0
	
	#make new germs
	for x in range(10):
		breedGerms()
		
	#delete old germs
	for curGerm in germs:
		curGerm.queue_free()
		
	#set new germ array
	germs = germBuffer
	
		
func breedGerms():
	#Get parents
	var parent1 = pickWeightedParent()
	var parent2 = pickWeightedParent()
	
	while(parent2 == parent1):
		parent2 = pickWeightedParent()
		
	#make new germ
	var tmp = germ.instantiate()
	
	#set genes to be average of parent genes
	for gene in tmp.genome:
		tmp[gene] = average(parent1.genome[gene], parent2.genome[gene])
	
	#add as a child and add to buffer
	add_child(tmp)
	germBuffer.append(tmp)
	
	
func pickWeightedParent():
	var totalWeight = 0
	for i in range(numGerms):
		totalWeight += i
	
	var randNum = randi_range(0, totalWeight)
	var currentWeight = 0
	
	for i in range(numGerms):
		currentWeight += i
		if(randNum <= currentWeight):
			return germs[i]
	
func average(num1, num2):
	return ((num1 + num2) / 2.0)
	
func moveBalloons(delta):
	for child in get_children():
		if(child.alive): #dont move dead children
			child.progress += child.genome.Speed * delta
