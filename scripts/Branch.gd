class_name Branch

var _from: Vector2
var _to: Vector2
var _color: Color
var _width: float
var _rotation: float
var _children: Array[Branch] = []


func _init(from: Vector2, to: Vector2, color: Color, width: float, rotation: float):
    _from = from
    _to = to
    _color = color
    _width = width
    _rotation = rotation

func get_from() -> Vector2:
    return _from


func get_to() -> Vector2:
    return _to


func set_to(to: Vector2):
    _to = to

func get_color() -> Color:
    return _color


func get_width() -> float:
    return _width


func get_rotation() -> float:
    return _rotation


func get_children() -> Array[Branch]:
    return _children


func add_child(child: Branch):
    _children.append(child)
