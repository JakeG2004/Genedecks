extends Node2D

@onready var collShape = get_node("Area2D/CollisionShape2D")

var genome = {"Frequency": .5, "Radius": 300, "Damage": 10, "RotateSpeed": 5, "ProjectileLife": 1}
var targets = []
var currentTarget
var shot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	collShape.shape.radius = genome["Radius"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#return if no targets
	if(targets.size() <= 0):
		return
		
	#choose target
	currentTarget = targets[randi_range(0, targets.size() - 1)]
	
	#rotate towards target
	var targetAngle = global_position.direction_to(currentTarget.global_position).angle() + (PI / 2)
	rotation = move_toward(rotation, targetAngle, delta * genome["RotateSpeed"])
	
	await attack()


func attack():
	#flag to prevent spam attacks
	if(shot):
		return
	shot = true

	currentTarget.currentHealth -= genome["Damage"]
	await get_tree().create_timer(genome["Frequency"]).timeout
	shot = false


func _on_area_2d_area_entered(area):
	#add to list
	if(area.is_in_group("germ")):
		targets.append(area.get_parent())


func _on_area_2d_area_exited(area):
	#remove from list if in list
	var tmp = area.get_parent()
	if(area.is_in_group("germ") && targets.has(tmp)):
		targets.remove_at(targets.find(tmp))
