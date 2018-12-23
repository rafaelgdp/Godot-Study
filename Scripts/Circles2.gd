extends Node2D

export (int) var rotation_ang = 50
export (Color, RGB) var color = ColorN("blue", 1)
export (int, 0, 360) var angle_from = 75
export (int, 0, 360) var angle_to = 195

func _ready():
	print("Estou executando do editor!")
	pass
	
func wrap(value, min_val, max_val):
    var f1 = value - min_val
    var f2 = max_val - min_val
    return fmod(f1, f2) + min_val

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()
    points_arc.push_back(center)
    var colors = PoolColorArray([color])

    for i in range(nb_points+1):
        var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
    draw_polygon(points_arc, colors)

func _draw():
   var center = Vector2(200, 200)
   var radius = 80
   draw_circle_arc_poly( center, radius, angle_from, angle_to, color )

func _process(delta):
	angle_from += rotation_ang * delta
	angle_to += rotation_ang * delta
    # we only wrap angles if both of them are bigger than 360
	if angle_from > 360 and angle_to > 360:
		angle_from = wrap(angle_from, 0, 360)
		angle_to = wrap(angle_to, 0, 360)
	update()
