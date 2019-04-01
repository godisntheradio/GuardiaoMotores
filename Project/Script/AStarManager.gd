extends Object

var astar : AStar

#Tamanho do mapa
var width : int
var height : int

var map : Map

func _init(map : Map):
	astar = AStar.new()
	width = map.width
	height = map.height
	self.map = map
	#Adiciona os pontos ao AStar
	for x in range(width):
		for y in range(height):
			astar.add_point(y * width + x, Vector3(x, y, 0))
	print(astar.get_point_position(4))
	
	#Conecta todos os pontos com seus vizinhos
	for pIdx in astar.get_points():
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
				
			astar.connect_points(get_point_id(Vector2(p.x, p.y)), get_point_id(n), false)

func get_point_id(p : Vector2):
	return p.y * width + p.x

func is_outside_bounds(p : Vector2):
	return (p.x < 0 || p.x >= width || p.y < 0 || p.y >= height)
	
func get_path(from : Vector2, to : Vector2):
	return astar.get_point_path(get_point_id(from), get_point_id(to))
	
#Retorna as posições dos tiles disponiveis para o movimento
func get_available_movement(origin : Vector2, movement : int):
	var indices = []
	indices.append({ "id": get_point_id(origin), "cost": 0 })
	for n in astar.get_point_connections(get_point_id(origin)):
		_available_movement_recurs(n, 0, movement, indices, true)
	indices.pop_front()
	var res = []
	for i in indices:
		res.append(astar.get_point_position(i.id))
	return res
	
func _available_movement_recurs(pId : int, currentCost : float, maxCost : float, outIds : Array, addSelf : bool):
	if map.get_tile(Vector2(pId % width, floor(pId / width))).occupying_unit != null:
		return
			
	var cost = astar.get_point_weight_scale(pId)
	if currentCost + cost > maxCost: 
		return
	else:
		if addSelf:
			outIds.append({ "id": pId, "cost": currentCost })
		for n in astar.get_point_connections(pId):
			for i in outIds:
				if i.id == n:
					if currentCost < i.cost:
						i.cost = currentCost
						_available_movement_recurs(n, currentCost + cost, maxCost, outIds, false)
					continue
			_available_movement_recurs(n, currentCost + cost, maxCost, outIds, true)