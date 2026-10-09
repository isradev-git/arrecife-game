(function (root) {
  'use strict';
  const WALK = .13, RUN = .255, MIN = .07, MAX = .92;
  const create = () => ({ velocity: 0, phase: 0, idle: 2, direction: 1, moving: false, running: false });
  function stop(m, front = false) { m.velocity = 0; m.moving = false; m.running = false; m.idle = front ? 2 : 0; }
  function step(m, x, { dt, intent = 0, target = null, running = false, height = .267, reduced = false }) {
    if (![dt, x, intent, height].every(Number.isFinite) || (target !== null && !Number.isFinite(target))) throw Error('Movimiento inválido');
    dt = Math.max(0, Math.min(dt, .05));
    if (target !== null) target = Math.max(MIN, Math.min(MAX, target));
    if (reduced && target !== null) { if (target !== x) m.direction = Math.sign(target - x); stop(m); return { x: target, arrived: true }; }
    let wish = Math.sign(intent) * (running ? RUN : WALK);
    if (target !== null) {
      const distance = target - x;
      wish = Math.sign(distance) * Math.min(running ? RUN : WALK, Math.sqrt(2 * 1.2 * Math.abs(distance)));
    }
    const acceleration = wish === 0 || Math.sign(wish) !== Math.sign(m.velocity) ? 1.3 : .95;
    m.velocity += Math.max(-acceleration * dt, Math.min(acceleration * dt, wish - m.velocity));
    let next = Math.max(MIN, Math.min(MAX, x + m.velocity * dt));
    const arrived = target !== null && ((target - x) * (target - next) <= 0 || Math.abs(target - next) < .001);
    if (arrived) next = target;
    const distance = Math.abs(next - x);
    m.running = Math.abs(m.velocity) > WALK * 1.15;
    m.moving = distance > .000001;
    if (m.moving) {
      m.direction = Math.sign(next - x); m.idle = 0;
      const stride = height * 941 / 1672 * (m.running ? 1.25 : .78);
      m.phase = (m.phase + distance / stride) % 1;
    } else m.idle += dt;
    if (arrived || next === MIN || next === MAX) { m.velocity = 0; m.moving = false; m.running = false; }
    return { x: next, arrived };
  }
  const api = { WALK, RUN, MIN, MAX, create, stop, step };
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
  else root.ArrecifeMotion = api;
})(globalThis);
