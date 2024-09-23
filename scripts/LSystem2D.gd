extends Node2D

@onready var line_container: Line2D = $LineContainer
@onready var tree_container: Node2D = $TreeContainer

@export var settings_panel: SettingsPanel

var generator = Generator.new()
var lines = []


func _ready():

    randomize()

    settings_panel.current_rule_changed.connect(_on_current_rule_changed)


func _on_current_rule_changed(rule):
    if rule != null:

        for line in line_container.get_children():
            line.queue_free()

        for branch in tree_container.get_children():
            branch.queue_free()

        var bottom_center: Vector2 = Vector2(get_viewport_rect().end.x / 2, get_viewport_rect().end.y)

        var iterations: int = 4 # randi_range(3, 5)
        var length_reduction: float = 0.9 # randf_range(0.3, 0.6)

        lines = generator.generate(bottom_center, iterations, length_reduction, Color(0.9, 0.6, 1.0, 0.7), 30.0, rule)

        _draw_branches(lines, line_container)

#        var polygon2d: Polygon2D = Polygon2D.new()
#        polygon2d.position = Vector2(500, 500)
#        var texture: Texture2D = load("res://assets/tree_bark.jpg") as Texture2D
#        polygon2d.texture = texture
#        polygon2d.texture_repeat = TEXTURE_REPEAT_ENABLED
#        var polygon: PackedVector2Array = PackedVector2Array()
#        polygon.append(Vector2(0, 0))
#        polygon.append(Vector2(50, 0))
#        polygon.append(Vector2(50, 100))
#        polygon.append(Vector2(0, 100))
#        #polygon2d.polygon = polygon
#
#        polygon.append(Vector2(-100, -100))
#        polygon.append(Vector2(-200, -100))
#        polygon.append(Vector2(-200, -200))
#        polygon.append(Vector2(-100, -200))
#
#        polygon.append(Vector2(-100, -200))
#        polygon.append(Vector2(-200, -200))
#        polygon.append(Vector2(-200, -300))
#        polygon.append(Vector2(-100, -300))
#
#        polygon2d.polygon = polygon #Geometry2D.merge_polygons(polygon, polygon2)
#
#        add_child(polygon2d)


func _draw_branches(branch: Branch, _line_container: Node2D):

    var static_body: StaticBody2D = StaticBody2D.new()
    var collision_shape: CollisionShape2D = CollisionShape2D.new()
    var rectangle_shape: RectangleShape2D = RectangleShape2D.new()

    rectangle_shape.set_size(Vector2(0.0, 0.0))
    collision_shape.set_shape(rectangle_shape)
    static_body.add_child(collision_shape)
    static_body.set_position(branch.get_from())
    static_body.set_rotation_degrees(branch.get_rotation())
    tree_container.add_child(static_body)

    var distance: float = branch.get_from().distance_to(branch.get_to())

    var tween: Tween = create_tween()
    tween.tween_property(collision_shape, "position:y", -distance/2, 1)
    tween.parallel().tween_property(rectangle_shape, "size:y", distance, 1)
    tween.parallel().tween_property(rectangle_shape, "size:x", branch.get_width(), 2)

    var polygon2d: Polygon2D = Polygon2D.new()
    static_body.add_child(polygon2d)
    var polygon: PackedVector2Array = PackedVector2Array()
    polygon.append(Vector2(branch.get_width() / 2, 0))
    polygon.append(Vector2(branch.get_width() / 2, -distance))
    polygon.append(Vector2(-branch.get_width() / 2, -distance))
    polygon.append(Vector2(-branch.get_width() / 2, 0))

    polygon2d.texture_scale = Vector2(3, 3)
    polygon2d.texture_repeat = TEXTURE_REPEAT_ENABLED

    var texture: Texture2D = load("res://assets/tree_bark.jpg") as Texture2D
    polygon2d.texture = texture

    tween.parallel().tween_property(polygon2d, "polygon", polygon, 1)

    await get_tree().create_timer(1).timeout

    #    var line2D: Line2D = Line2D.new()
    #    line2D.default_color = branch.get_color()
    #    line2D.width = branch.get_width()
    #    line2D.antialiased = true
    #    line2D.add_point(branch.get_from())
    #    line2D.add_point(branch.get_to())
    #    _line_container.add_child(line2D)


    for child_branch in branch.get_children():
        _draw_branches(child_branch, _line_container)
