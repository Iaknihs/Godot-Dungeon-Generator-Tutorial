extends TileMap


enum Tiles {
	blue = 0,
	red = 1,
	white = 2,
	brown = 3,
	black = 4
}

export var width = 41
export var height = 18

var start_x
var start_y
var end_x
var end_y

var generation_complete = false

func _ready():
	# assert uneven number
	if width % 2 != 1:
		width -= 1
	if height % 2 != 1:
		height -= 1
	
	var x_scale = 1920/(width*32.0)
	var y_scale = 1080/(height*32.0)
	scale = Vector2(x_scale, y_scale)
	
	for i in range(width):
		for j in range(height):
			# surrounding wall
			if i == 0 or j == 0 or i == width-1 or j == height-1:
				set_cell(i, j, Tiles.black)
			# regular wall
			elif i%2 == 0 or j%2 == 0:
				set_cell(i, j, Tiles.black)
			# floor
			else:
				set_cell(i, j, Tiles.white)
	
	randomize()
	
	start_x = 0
	start_y = 3
	
	end_x = width-1
	end_y = height-4
	
	set_cell(start_x, start_y, Tiles.brown)
	set_cell(end_x, end_y, Tiles.brown)
	
	rdf_init()
	
	while not generation_complete:
		rdf_step()
	
	for x in range(width):
		for y in range(height):
			if get_cell(x, y) == Tiles.blue:
				set_cell(x, y, Tiles.white)
	
	$Player.position = 32 * Vector2(start_x+0.5, start_y+0.5)


var rdf_stack = []
func rdf_init():
	var offsets = [[1, 0], [-1, 0], [0, 1], [0, -1]]
	
	for o in offsets:
		if get_cell(start_x + o[0], start_y + o[1]) == Tiles.white:
			rdf_stack.push_back(Vector2(start_x + o[0], start_y + o[1]))
	set_cellv(rdf_stack[0], Tiles.red)

func rdf_step():
	if len(rdf_stack) <= 0:
		generation_complete = true
		return
	
	var curr = rdf_stack.pop_back()
	var next
	var found = false
	
	# check neighbors in random order
	var check_order = [[2,0], [-2, 0], [0, 2], [0, -2]]
	check_order.shuffle()
	for val in check_order:
		next = Vector2(val[0], val[1])
		if get_cellv(curr + next) == Tiles.white:
			found = true
			break
	
	if found:
		rdf_stack.push_back(curr)
		set_cellv(curr + (next/2), Tiles.brown)
		set_cellv(curr + next, Tiles.red)
		set_cellv(curr, Tiles.brown)
		rdf_stack.push_back(curr+next)
	else:
		set_cellv(curr, Tiles.blue)
		for dir in [[1,0], [0,1], [-1,0], [0,-1]]:
			var dir_vec = Vector2(dir[0], dir[1])
			if get_cellv(curr+dir_vec) == Tiles.brown and get_cellv(curr+(dir_vec*2)) == Tiles.blue:
				set_cellv(curr+dir_vec, Tiles.blue)
		if len(rdf_stack) > 0 and rdf_stack[0] != null:
			set_cellv(rdf_stack.back(), Tiles.red)
		










