(() => {
  'use strict';
  const E = ArrecifeEngine, C = ArrecifeContent, evidence = ArrecifeEvidence, M = ArrecifeMotion;
  const motion = M.create();
  const $ = id => document.getElementById(id);
  const key = 'arrecife:pase-pendiente:v1';
  let storageError = false;
  function stored(name) { try { return localStorage.getItem(name); } catch { storageError = true; return null; } }
  function write(name, value) { try { localStorage.setItem(name, value); } catch { if (!storageError) toast('No se pudo guardar en este navegador. Mantén abierta la partida.'); storageError = true; } }
  const restored = E.restore(stored(key));
  let state = restored.state, playing = false, dialogue = null, destination = null, timer = 0, tick = 0, runMode = false;
  const images = {}, keys = new Set();
  let labels = false, reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
  const canvas = $('scene'), ctx = canvas.getContext('2d'), panel = $('panel');
  function toast(message) { $('toast').textContent = message; $('toast').classList.add('show'); clearTimeout(timer); timer = setTimeout(() => $('toast').classList.remove('show'), 5000); }
  function save() { write(key, JSON.stringify(state)); }
  function event(action) { state = E.reduce(state, action); save(); update(); }
  function button(text, action, className = '') { const b = document.createElement('button'); b.textContent = text; b.className = className; b.onclick = action; return b; }
  function text(tag, value, className = '') { const el = document.createElement(tag); el.textContent = value; el.className = className; return el; }
  function modal(title, kicker = 'Pase pendiente') {
    destination = null; keys.clear(); M.stop(motion); $('panel-title').textContent = title; $('panel-kicker').textContent = kicker; $('panel-body').replaceChildren();
    if (!panel.open) panel.showModal();
    return $('panel-body');
  }
  function close() { panel.close(); }
  $('close-panel').onclick = close;
  function available() { return C.scenes[state.scene].hotspots.filter(h => !h.needs || state.flags[h.needs]); }
  function update() {
    const scene = C.scenes[state.scene];
    $('location').textContent = scene.area; $('scene-name').textContent = scene.name; $('objective').textContent = E.objective(state);
    $('doc-count').textContent = state.docs.length;
    for (const id of ['explore-button', 'notebook-button', 'map-button', 'run-button', 'front-button']) $(id).disabled = !!dialogue || (state.flags.ended && id !== 'notebook-button');
    $('run-button').setAttribute('aria-pressed', runMode);
    canvas.setAttribute('aria-label', `${scene.description} Sota puede caminar e investigar los puntos disponibles en Explorar.`);
    $('hotspots').replaceChildren(); $('hotspots').classList.toggle('subtle', !labels);
    if (playing && !dialogue && !state.flags.ended) for (const h of available()) {
      const b = button('', () => approach(h), 'hotspot'); b.append(text('span', h.label)); b.style.left = `${h.x * 100}%`; b.style.top = `${h.y * 100}%`; $('hotspots').append(b);
    }
    $('hud').hidden = !playing; $('controls').hidden = !playing; $('ending').hidden = !playing || !state.flags.ended;
    draw();
  }
  function draw() {
    const scene = C.scenes[state.scene], bg = images[state.scene === 'taller' && state.flags.met ? 'taller_con_iria_v1.png' : scene.image];
    if (!bg) return;
    ctx.clearRect(0, 0, canvas.width, canvas.height); ctx.drawImage(bg, 0, 0, 1672, 941);
    ArrecifeAtmosphere.draw(ctx, state.scene, tick, reduced);
    const moving = motion.moving && !reduced;
    const facingFront = !moving && !dialogue && motion.idle > 1.3;
    const turning = !moving && !dialogue && motion.idle > .85 && !facingFront;
    const atlas = ArrecifeSprites[moving ? (motion.running ? 'run' : 'walk') : 'idle'];
    const sprite = images[atlas.file]; if (!sprite) return;
    const frame = moving ? Math.floor(motion.phase * 8) % 8 : facingFront ? 2 : turning ? 1 : 0;
    const w = sprite.width / atlas.columns, h = sprite.height / atlas.rows;
    const scale = scene.height * 941 / atlas.heights[frame];
    const breath = !reduced && !moving ? Math.sin(tick * 1.7) * .004 : 0;
    ctx.save(); ctx.translate(state.x * 1672, scene.floor * 941);
    ctx.fillStyle = '#050b1266'; ctx.beginPath(); ctx.ellipse(0, -1, scene.height * 110, scene.height * 19, 0, 0, Math.PI * 2); ctx.fill();
    // The frontal atlas is never mirrored: her deck stays on her right hip.
    ctx.scale(facingFront ? 1 : motion.direction, 1 + breath);
    ctx.transform(1, 0, !reduced && !moving ? Math.sin(tick * .7) * .002 : 0, 1, 0, 0);
    const [left, right] = atlas.cuts?.[frame] || [0, w];
    ctx.drawImage(sprite, (frame % atlas.columns) * w + left, Math.floor(frame / atlas.columns) * h, right - left, h,
      (left - atlas.pivots[frame]) * scale, -atlas.bases[frame] * scale, (right - left) * scale, h * scale);
    ctx.restore();
  }
  function approach(h) {
    if (!playing || dialogue || state.flags.ended) return;
    close(); destination = { run: runMode, x: Math.max(.08, Math.min(.90, h.x - .065)), action: () => { motion.direction = Math.sign(h.x - state.x) || motion.direction; interact(h.id); } };
    if (reduced) { motion.direction = Math.sign(destination.x - state.x) || motion.direction; M.stop(motion); state.x = destination.x; const done = destination.action; destination = null; save(); done(); }
  }
  function choices(title, ids) {
    const body = modal(title, C.scenes[state.scene].area), list = text('div', '', 'choices'); body.append(list);
    for (const id of ids) { const c = C.conversations[id]; list.append(button(c.title + (state.conversations.includes(id) ? ' · Escuchado' : ''), () => talk(id), state.conversations.includes(id) ? 'done' : '')); }
  }
  function interact(id) {
    if (id === 'rutas') return map();
    if (id === 'vestuario' || id === 'recepcion') return travel(id === 'recepcion' ? 'fiebre' : id);
    if (id === 'jefa') {
      if (!state.flags.accepted) return talk('encargo');
      if (state.flags.report) return talk('coda');
      return choices('La jefa de la Nómina', ['confirmacion', 'cordon', 'cobertura']);
    }
    if (id === 'sanz') return choices('Sanz', ['expediente', 'dinero', ...(E.has(state, 'P3') ? ['acuerdo'] : []), ...(E.has(state, 'P4') ? ['lectura'] : []), ...(state.deductions.includes('D2') ? ['confronto'] : []), 'carpeta', 'poder']);
    if (id === 'berta' || id === 'iria') return state.flags.met ? choices(id === 'berta' ? 'Berta e Iria' : 'Iria', ['copia', 'nota', 'silencio', 'ayuda_iria', 'deck']) : talk('berta');
    talk(id);
  }
  function talk(id) {
    close(); destination = null; keys.clear(); M.stop(motion); dialogue = { id, line: 0 }; $('dialogue').hidden = false; showLine(); update(); $('next-line').focus();
  }
  function showLine() {
    const c = C.conversations[dialogue.id], [speaker, words] = c.lines[dialogue.line];
    $('speaker').textContent = speaker || C.scenes[state.scene].name; $('speech').textContent = words; $('speech').classList.toggle('narration', !speaker);
    $('line-counter').textContent = `${dialogue.line + 1} / ${c.lines.length}`;
    $('next-line').textContent = dialogue.line === c.lines.length - 1 ? (c.docs ? 'Guardar copias' : 'Terminar') : 'Continuar';
  }
  $('next-line').onclick = () => {
    if (!dialogue) return;
    const c = C.conversations[dialogue.id];
    if (++dialogue.line < c.lines.length) return showLine();
    const id = dialogue.id; dialogue = null; $('dialogue').hidden = true;
    if (c.effect) event({ type: c.effect });
    event({ type: 'conversation', id });
    if (c.docs) { toast('Copias guardadas en la libreta.'); notebook('Documentos', c.docs[0]); }
    else $('explore-button').focus();
  };
  function travel(scene) {
    if (!E.canTravel(state, scene)) return toast(scene === 'vestuario' ? 'Habla primero con la jefa sobre el encargo.' : 'Lee la dirección en los documentos de la libreta.');
    close(); destination = null; M.stop(motion, true); const before = state.docs.length;
    event({ type: 'travel', scene });
    if (state.docs.length > before) toast('Sanz entrega el expediente y la carpeta de Iria. Copias en la libreta.');
    const intro = `${scene}_intro`;
    if (C.conversations[intro] && !state.conversations.includes(intro)) talk(intro);
  }
  function map() {
    const body = modal('Recorrido', 'Cotas de El Arrecife');
    for (const id of E.SCENES) {
      if (id === 'vestuario' && !state.flags.accepted) continue;
      if (id === 'nudo' && !E.has(state, 'P1')) continue;
      if (id === 'taller' && !E.has(state, 'P5')) continue;
      const scene = C.scenes[id], row = text('div', '', 'map-stop'), copy = text('div', '');
      row.append(text('span', ({ fiebre: '04', vestuario: '04', nudo: '03', taller: '00' })[id], 'cota'));
      copy.append(text('h3', scene.name), text('p', scene.area)); row.append(copy);
      const b = button(id === state.scene ? 'Estás aquí' : 'Ir', () => travel(id)); b.disabled = id === state.scene || !E.canTravel(state, id);
      if (!E.canTravel(state, id)) copy.append(text('p', 'Lee el documento con la dirección para localizarlo.'));
      row.append(b); body.append(row);
    }
  }
  function explore() {
    const body = modal('Explorar', C.scenes[state.scene].name), list = text('div', '', 'choices'); body.append(list);
    for (const h of available()) list.append(button(h.label, () => approach(h)));
  }
  function documentCard(id) {
    const article = text('article', '', 'document');
    article.append(text('p', `${id} · ${C.sources[id]}`, 'provenance'), text('h2', evidence[id].title));
    const copy = document.createElement('div'); copy.innerHTML = evidence[id].html; article.append(copy); return article;
  }
  function notebook(tab = 'Documentos', selected = null) {
    const body = modal('Libreta de Sota', 'Documentos y conclusiones'), tabs = text('nav', '', 'panel-tabs'); tabs.setAttribute('aria-label', 'Secciones de la libreta');
    for (const name of ['Documentos', 'Contrastar', 'Conclusiones', 'Informe']) { const b = button(name, () => notebook(name)); b.setAttribute('aria-pressed', name === tab); tabs.append(b); }
    body.append(tabs);
    if (tab === 'Documentos') {
      if (!state.docs.length) return body.append(text('p', 'Todavía no has recibido documentos.', 'document-empty'));
      const id = selected || state.docs.find(d => !state.read.includes(d)) || state.docs[0];
      if (!state.read.includes(id)) event({ type: 'read', id });
      const layout = text('div', '', 'document-layout'), list = text('nav', '', 'document-list'); list.setAttribute('aria-label', 'Documentos recogidos');
      for (const doc of E.DOCS.filter(d => state.docs.includes(d))) {
        const b = button('', () => notebook('Documentos', doc)); b.append(text('small', doc), text('span', evidence[doc].title, state.read.includes(doc) ? '' : 'new')); b.setAttribute('aria-pressed', id === doc); list.append(b);
      }
      layout.append(list, documentCard(id)); body.append(layout);
    } else if (tab === 'Contrastar') comparison(body);
    else if (tab === 'Conclusiones') {
      if (!state.deductions.length) body.append(text('p', 'Las conclusiones que puedas sostener aparecerán aquí. Compara documentos en «Contrastar».'));
      for (const id of state.deductions) { const fact = text('section', '', 'fact'); fact.append(text('h3', C.deductions[id].title), text('p', C.deductions[id].summary)); body.append(fact); }
      if (state.flags.permission) body.append(text('p', 'Iria autoriza informar a la jefa y usar las copias para reclamar. Su refugio no se comunica a Sanz.', 'conclusion'));
    } else report(body);
  }
  function selectField(label, options, id) {
    const wrap = text('div', '', 'field'), caption = text('label', label), select = document.createElement('select'); caption.htmlFor = id; select.id = id;
    for (const [value, title] of options) { const option = text('option', title); option.value = value; select.append(option); }
    wrap.append(caption, select); return { wrap, select };
  }
  function comparison(body) {
    const choice = selectField('Pregunta que quieres resolver', Object.entries(C.deductions).map(([id, d]) => [id, d.title]), 'deduction'); body.append(choice.wrap);
    const area = text('div', ''); body.append(area);
    function render() {
      area.replaceChildren(); const id = choice.select.value, d = C.deductions[id];
      const pairs = text('div', '', 'pair-selectors'), previews = text('div', '', 'comparison');
      const options = [['', 'Elige una prueba'], ...E.DOCS.filter(x => state.docs.includes(x)).map(x => [x, `${x} · ${evidence[x].title}`])];
      const fields = [selectField('Primera prueba', options, 'first-proof'), selectField('Segunda prueba', options, 'second-proof')];
      for (const f of fields) { pairs.append(f.wrap); f.select.onchange = () => { previews.replaceChildren(); for (const field of fields) if (field.select.value) { event({ type: 'read', id: field.select.value }); previews.append(documentCard(field.select.value)); } }; }
      const group = text('fieldset', '', 'answer-group'); group.append(text('legend', d.question));
      for (const [value, words] of d.answers) { const label = text('label', ''), input = document.createElement('input'); input.type = 'radio'; input.name = 'answer'; input.value = value; label.append(input, text('span', words)); group.append(label); }
      const feedback = text('p', '', 'feedback'); feedback.hidden = true; feedback.setAttribute('role', 'status');
      const actions = text('div', '', 'form-actions');
      actions.append(button('Registrar conclusión', () => {
        const pair = fields.map(f => f.select.value), answer = group.querySelector('input:checked')?.value;
        feedback.hidden = false; feedback.className = 'feedback';
        if (!answer) { feedback.textContent = 'Elige la afirmación que sostienen las dos pruebas.'; return; }
        try { event({ type: 'deduce', id, pair, answer }); feedback.textContent = d.summary; feedback.classList.add('success'); }
        catch { feedback.textContent = d.pair.every(p => pair.includes(p)) ? (d.feedback[answer] || 'Aún faltan pruebas.') : 'Esas dos pruebas no sostienen esta conclusión. Revisa qué documento contiene cada afirmación.'; }
      }, 'primary'), button('Pedir una pista', () => { event({ type: 'hint', id }); feedback.hidden = false; feedback.className = 'feedback'; feedback.textContent = d.hints[state.hints[id] - 1]; }));
      area.append(pairs, previews, group, actions, feedback);
      if (state.deductions.includes(id)) area.append(text('p', 'Conclusión ya registrada. Puedes revisar cómo la sostienen las pruebas.', 'small-note'));
    }
    choice.select.onchange = render; render();
  }
  function report(body) {
    const missing = E.reportMissing(state);
    if (missing) { body.append(text('p', missing, 'feedback')); const unread = state.docs.filter(d => !state.read.includes(d)); for (const id of unread) body.append(button(`Leer ${id}`, () => notebook('Documentos', id))); return; }
    if (state.flags.report) { body.append(text('p', state.flags.ended ? 'El informe está archivado. Iria recibió dos láminas; la tercera sigue reclamada.' : 'El informe está preparado. Falta entregarlo a la jefa en la Fiebre.', 'conclusion')); if (!state.flags.ended) body.append(button('Volver a la Fiebre', () => travel('fiebre'), 'primary')); return; }
    body.append(text('p', 'Las pruebas siguen disponibles en la libreta. Deja constancia de lo que vas a comunicar.'));
    const money = selectField('¿Qué cantidad del depósito debe devolver Sanz?', [['', 'Elige una cantidad'], ['315', '315 universales: depósito y comisión'], ['300', '300 universales: las tres láminas del depósito'], ['285', '285 universales: depósito menos comisión']], 'money');
    const silence = selectField('¿Qué explica que la nota no haya llegado?', [['', 'Elige una explicación'], ['intercepted', 'Alguien interceptó el envío'], ['planned', 'El reparto está previsto para mañana; Iria eligió esperar'], ['nocall', 'Era imposible llamar desde el taller']], 'silence');
    const will = selectField('¿Qué autoriza Iria?', [['', 'Elige cómo proceder'], ['forced', 'Devolverla a quien paga la búsqueda'], ['voluntary', 'Informar a la jefa y reclamar; Iria decide cuándo volver'], ['sanz', 'Comunicar su refugio a Sanz']], 'will');
    body.append(money.wrap, silence.wrap, will.wrap);
    const feedback = text('p', '', 'feedback'); feedback.hidden = true; feedback.setAttribute('role', 'status');
    body.append(button('Preparar el informe', () => {
      const values = { money: money.select.value, silence: silence.select.value, will: will.select.value };
      try { event({ type: 'report', ...values }); notebook('Informe'); }
      catch { feedback.hidden = false; feedback.textContent = Object.values(values).some(x => !x) ? 'Completa las tres conclusiones.' : values.money !== '300' ? 'P3 separa el depósito de la comisión. Revisa qué cantidad está garantizada.' : values.silence !== 'planned' ? 'Contrasta la fecha del reparto con lo que Iria y Berta te contaron.' : 'Iria autoriza ayuda y reclamación. Conserva su decisión y la reserva sobre su refugio.'; }
    }, 'primary'), feedback);
  }
  function start(fresh = false) {
    close(); if (fresh) { state = E.initial(); save(); }
    playing = true; dialogue = null; destination = null; M.stop(motion, true); $('dialogue').hidden = true; $('title-screen').hidden = true; update(); $('explore-button').focus();
  }
  function restart() {
    const body = modal('Empezar de nuevo'); body.append(text('p', 'Esto sustituirá la partida guardada en este navegador. Los archivos del proyecto se conservan.'));
    body.append(button('Conservar mi partida', close), button('Borrar esta partida y empezar', () => start(true), 'danger'));
  }
  function menu() { close(); playing = false; dialogue = null; destination = null; keys.clear(); M.stop(motion, true); $('dialogue').hidden = true; $('title-screen').hidden = false; $('continue-button').hidden = !state.flags.accepted; update(); }
  function options() {
    const body = modal('Opciones');
    for (const [label, checked, change] of [['Mostrar nombres de los puntos', labels, value => { labels = value; update(); }], ['Reducir movimiento', reduced, value => { reduced = value; if (value) M.stop(motion, true); draw(); }]]) {
      const row = text('label', '', 'setting'), input = document.createElement('input'); input.type = 'checkbox'; input.checked = checked; input.onchange = () => change(input.checked); row.append(input, text('span', label)); body.append(row);
    }
    const size = selectField('Tamaño del texto', [['1', 'Normal'], ['1.15', 'Grande'], ['1.3', 'Muy grande']], 'text-size'); size.select.value = document.documentElement.style.getPropertyValue('--size') || '1'; size.select.onchange = () => document.documentElement.style.setProperty('--size', size.select.value); body.append(size.wrap);
    body.append(text('p', 'Camina con las flechas o A/D, o pulsa el suelo. Mantén Mayús o activa «Correr» para correr; doble clic corre hasta un punto. F o «De frente» detiene a Sota y la gira. Al descansar, respira y se orienta hacia ti. E interactúa cerca; J abre la libreta, M el recorrido y H muestra los puntos. «Explorar» permite acceder a cada interacción sin buscarla en la imagen.', 'small-note'));
    body.append(text('p', storageError ? 'El almacenamiento del navegador no está disponible. La partida no se conservará al cerrar.' : 'Guardado automático en este navegador. Las conversaciones se guardan al terminarlas.', 'small-note'));
    if (playing) body.append(button('Volver al menú', menu), button('Empezar de nuevo', restart, 'danger'));
  }
  $('start-button').onclick = () => state.flags.accepted ? restart() : start(true);
  $('continue-button').onclick = () => start(); $('options-button').onclick = options;
  $('menu-link').onclick = e => { e.preventDefault(); menu(); };
  $('explore-button').onclick = explore; $('notebook-button').onclick = () => notebook(); $('map-button').onclick = map;
  $('review-button').onclick = () => notebook('Conclusiones'); $('end-menu').onclick = menu;
  $('run-button').onclick = () => { runMode = !runMode; if (destination) destination.run = runMode; update(); };
  function front() { destination = null; keys.clear(); M.stop(motion, true); save(); draw(); }
  $('front-button').onclick = front;
  function goToPointer(e, run = false)  { if (!playing || dialogue || panel.open || state.flags.ended) return; const rect = canvas.getBoundingClientRect(); destination = { x: Math.max(.07, Math.min(.92, (e.clientX - rect.left) / rect.width)), run: run || runMode || e.shiftKey }; }
  canvas.onclick = e => goToPointer(e);
  canvas.ondblclick = e => { e.preventDefault(); goToPointer(e, true); };
  document.addEventListener('keydown', e => {
    if (panel.open || /INPUT|SELECT|TEXTAREA/.test(e.target.tagName)) return;
    if (dialogue) { if (e.key === ' ' && e.target !== $('next-line')) { e.preventDefault(); $('next-line').click(); } return; }
    if (!playing || state.flags.ended) return;
    const k = e.key.toLowerCase();
    if (k === 'shift') keys.add(k);
    if (['arrowleft', 'arrowright', 'a', 'd'].includes(k)) { e.preventDefault(); keys.add(k); destination = null; }
    if (e.repeat) return;
    if (k === 'f') front();
    if (k === 'j') notebook(); if (k === 'm') map(); if (k === 'h') { labels = !labels; update(); }
    if (k === 'e') { const h = available().reduce((a, b) => Math.abs(a.x - state.x) < Math.abs(b.x - state.x) ? a : b); if (Math.abs(h.x - state.x) < .18) approach(h); else toast('Acércate a un punto o usa Explorar.'); }
  });
  document.addEventListener('keyup', e => { if (keys.delete(e.key.toLowerCase()) && playing) save(); });
  window.addEventListener('blur', () => { keys.clear(); destination = null; M.stop(motion); if (playing) save(); });
  document.addEventListener('visibilitychange', () => { if (document.hidden) { keys.clear(); destination = null; M.stop(motion); if (playing) save(); } });
  let last = 0;
  function loop(now) {
    if (now - last >= 1000 / 30) {
      const dt = Math.min((now - last) / 1000, .05); last = now;
      if (!document.hidden) {
        if (!panel.open) tick += dt;
        if (playing && !dialogue && !panel.open && !state.flags.ended) {
          const intent = (keys.has('arrowright') || keys.has('d') ? 1 : 0) - (keys.has('arrowleft') || keys.has('a') ? 1 : 0);
          const wasMoving = motion.moving;
          const next = M.step(motion, state.x, { dt, intent, target: destination?.x ?? null,
            running: runMode || keys.has('shift') || !!destination?.run, height: C.scenes[state.scene].height, reduced });
          state.x = next.x;
          if (next.arrived && destination) { const done = destination.action; destination = null; save(); if (done) done(); }
          else if (wasMoving && !motion.moving) save();
        }
        if (!panel.open) draw();
      }
    }
    requestAnimationFrame(loop);
  }
  const files = [...new Set([...Object.values(C.scenes).map(s => s.image), 'taller_con_iria_v1.png', ...Object.values(ArrecifeSprites).map(a => a.file)])];
  Promise.all(files.map(file => new Promise((resolve, reject) => { const img = new Image(); img.onload = () => { images[file] = img; resolve(); }; img.onerror = () => reject(Error(`No se pudo cargar ${file}`)); img.src = `assets/${file}`; })))
    .then(() => { $('start-button').disabled = false; $('continue-button').hidden = !restored.valid || !state.flags.accepted; $('loading').textContent = restored.reason || (storageError ? 'Sin guardado persistente en este navegador.' : ''); update(); requestAnimationFrame(loop); })
    .catch(error => { $('loading').textContent = `${error.message}. Revisa los archivos de assets y vuelve a abrir el juego.`; });
})();
