extends RefCounted

const MIN_X = 128.0
const MAX_X = 1632.0
const WALK_SPEED = 220.0
const ACCELERATION = 1600.0
const BRAKING = 2200.0

var velocity := 0.0
var target: Variant = null
var arrived := false


func go_to(x: float) -> bool:
	if not is_finite(x):
		return false
	target = clampf(x, MIN_X, MAX_X)
	return true


func stop() -> void:
	velocity = 0.0
	target = null
	arrived = false


func step(x: float, delta: float, intent: float) -> float:
	assert(is_finite(x) and is_finite(delta) and is_finite(intent))
	var dt := clampf(delta, 0.0, 0.05)
	arrived = false
	if intent != 0.0:
		target = null
	var wish := signf(intent) * WALK_SPEED
	if target != null:
		wish = signf(target - x) * minf(WALK_SPEED, sqrt(2.0 * BRAKING * absf(target - x)))
	var acceleration := BRAKING if wish == 0.0 or signf(wish) != signf(velocity) else ACCELERATION
	velocity = move_toward(velocity, wish, acceleration * dt)
	var next := clampf(x + velocity * dt, MIN_X, MAX_X)
	if target != null and ((target - x) * (target - next) <= 0.0 or absf(target - next) < 0.25):
		next = target
		stop()
		arrived = true
	elif next == MIN_X or next == MAX_X:
		velocity = 0.0
	return next
