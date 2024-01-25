extends Resource
class_name Oscillator

var x: float = 0.0
var fwd: bool = false
@export var start: float = 0.0
@export var end: float = 1.0
@export var mult: float = 1.0
@export var ease_type: EaseType = EaseType.LINEAR
@export var varpath: Array[String]

enum EaseType { LINEAR, SINE, QUADRATIC, CUBIC, QUINTIC }

func process(delta) -> float:
	x += (1 if fwd else -1) * mult * delta
	if x >= 1.0:
		fwd = false
	elif x <= 0.0:
		fwd = true
	var interpolated = 0.0
	if ease_type == EaseType.LINEAR:
		interpolated = x
	elif ease_type == EaseType.SINE:
		interpolated = -(cos(3.142 * x) - 1) / 2
	elif ease_type == EaseType.QUADRATIC:
		interpolated = (2 * x * x) if x < 0.5 else (1 - pow(-2 * x + 2, 2) / 2)
	elif ease_type == EaseType.CUBIC:
		interpolated = (4 * x * x * x) if x < 0.5 else (1 - pow(-2 * x + 2, 3) / 2)
	elif ease_type == EaseType.QUINTIC:
		interpolated = (16 * x * x * x * x * x) if (x < 0.5) else (1 - pow(-2 * x + 2, 5) / 2)
	return lerp(start, end, interpolated)
