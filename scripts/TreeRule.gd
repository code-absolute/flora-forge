extends Rule
class_name TreeRule

func _init():
    self.axiom = "X"
    self.angle = 20
    self.rules = {
        "F": "FF",
        "X": "F[+X]F[-X]+X",
    }
    self.actions = {
        "F": "draw_forward",
        "X": "draw_forward",
        "+": "rotate_right",
        "-": "rotate_left",
        "[": "store",
        "]": "load",
    }
