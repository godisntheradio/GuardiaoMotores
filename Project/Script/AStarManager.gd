extends Object

var astar : AStar

#Tamanho do mapa
var width : int
var height : int

var map : Map

func _init(map : Map):
	self.map = map
	astar = AStar.new()
	width = map.width
	height = map.height
	#Adiciona os pontos ao AStar
	for x in range(width):
		for y in range(height):
			astar.add_point(y * width + x, Vector3(x, y, 0))
	update_connections()

func update_connections():
	#Conecta todos os pontos com seus vizinhos
	var points = astar.get_points()
	for p in points:
		clear_connections(p)
	for pIdx in points:
		var p = astar.get_point_position(pIdx)
		var neighbours = PoolVector2Array([
			Vector2(p.x + 1, p.y),
			Vector2(p.x - 1, p.y),
			Vector2(p.x, p.y + 1),
			Vector2(p.x, p.y - 1)
		])
		
		for n in neighbours:
			if is_outside_bounds(n):
				continue
			if !astar.has_point(get_point_id(n)):
				continue
			if map.get_tile(n).occupying_unit != null:
				#print("P:"+str(p)+"  N:"+str(n))
				continue
			astar.connect_points(get_point_id(Vector2(p.x, p.y)), get_point_id(n), false)
		if p == Vector3(1, 0, 0):
			print(get_connection_positions(Vector2(0, 0)))
	
func clear_connections(tileId : int):
	var con = astar.get_point_connections(tileId)
	for c in con:
		astar.disconnect_points(tileId, c)

func get_point_id(p : Vector2):
	return p.y * width + p.x

func is_outside_bounds(p : Vector2):
	return (p.x < 0 || p.x >= width || p.y < 0 || p.y >= height)

#recebe posição na matriz
func get_path(from : Vector2, to : Vector2):
	return astar.get_point_path(get_point_id(from), get_point_id(to))
	
func get_neighbour_positions(p : Vector2):
	var neighbour_positions = PoolVector2Array([
		Vector2(p.x + 1, p.y),
		Vector2(p.x - 1, p.y),
		Vector2(p.x, p.y + 1),
		Vector2(p.x, p.y - 1)
	])
	var res = []
	for n in neighbour_positions:
		if !is_outside_bounds(n):
			res.append(n)
			
	return res
	
func get_connection_positions(p : Vector2):
	var cons = astar.get_point_connections(p.y * width + p.x)
	var res = []
	for c in cons:
		var con_p = astar.get_point_position(c)
		res.append(Vector2(con_p.x, con_p.y))
	return res
	
#Retorna as posições dos tiles disponiveis para o movimento
func get_available_movement(origin : Vector2, movement : int, include_units : bool = false, consider_costs : bool = true):
	var indices = []
	
	indices.append({ "pos": origin, "cost": 0 })
	for n in get_neighbour_positions(origin):
		_available_movement_recurs(n, 0, movement, include_units, consider_costs, indices, true)
	indices.pop_front()
	
	var res = []
	for i in indices:
		res.append(i.pos)
	return res
	
func _available_movement_recurs(pos : Vector2, currentCost : float, maxCost : float, include_units : bool, consider_costs : bool, outIds : Array, addSelf : bool):
	var tile = map.get_tile(pos)
	
	if !include_units && !tile.is_tile_empty():
		return
			
	var cost = 1
	if(consider_costs):
		cost = tile.get_cost()
		
	if currentCost + cost > maxCost: 
		return
	else:
		if addSelf:
			outIds.append({ "pos": pos, "cost": currentCost })
		for n in get_neighbour_positions(pos):
			var found = false
			for i in outIds:
				if i.pos == n:
					found = true
					if currentCost < i.cost:
						i.cost = currentCost
						_available_movement_recurs(n, currentCost + cost, maxCost, include_units, consider_costs, outIds, false)
					break
			if found:
				continue
			_available_movement_recurs(n, currentCost + cost, maxCost, include_units, consider_costs, outIds, true)