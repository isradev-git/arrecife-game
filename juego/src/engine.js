(function (root) {
  'use strict';
  const DOCS = ['E0', 'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7'];
  const SCENES = ['fiebre', 'vestuario', 'nudo', 'taller'];
  const FLAGS = ['accepted', 'met', 'explained', 'permission', 'report', 'ended'];
  const initial = () => ({ version: 1, scene: 'fiebre', x: .47, docs: [], read: [], deductions: [], flags: Object.fromEntries(FLAGS.map(k => [k, false])), visited: ['fiebre'], hints: {}, conversations: [] });
  const has = (s, ...ids) => ids.every(id => s.docs.includes(id));
  function canTravel(s, scene) {
    return scene === 'fiebre' || (scene === 'vestuario' && s.flags.accepted) || (scene === 'nudo' && s.read.includes('P1')) || (scene === 'taller' && s.read.includes('P5'));
  }
  function reportMissing(s) {
    if (!s.flags.met) return 'Primero necesitas hablar con Iria.';
    if (!['P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7'].every(id => s.read.includes(id))) return 'Lee las siete pruebas que has encontrado. Las copias siguen en la libreta.';
    if (!s.deductions.includes('D2')) return 'Falta comprobar qué sabía Sanz cuando confirmó el acceso. Puedes hacerlo en «Contrastar».';
    if (!s.flags.explained) return 'Pregunta a Iria por qué eligió esperar al reparto.';
    if (!s.flags.permission) return 'Habla con Iria sobre qué ayuda acepta y a quién puedes informar.';
    return '';
  }
  function reduce(state, event) {
    const s = JSON.parse(JSON.stringify(state));
    const give = (...ids) => { s.docs = [...new Set([...s.docs, ...ids])]; };
    const check = (condition, message) => { if (!condition) throw new Error(message); };
    switch (event.type) {
      case 'accept':
        check(s.scene === 'fiebre', 'El encargo se acepta en la Fiebre.');
        s.flags.accepted = true; give('E0', 'P2'); break;
      case 'papers':
        check(s.flags.accepted && s.scene === 'vestuario', 'Revisa los papeles de Iria en su casillero.');
        give('P1', 'P3'); break;
      case 'read':
        check(has(s, event.id), 'Todavía no tienes este documento.');
        s.read = [...new Set([...s.read, event.id])]; break;
      case 'travel':
        check(SCENES.includes(event.scene) && canTravel(s, event.scene), 'Necesitas una dirección antes de ir allí.');
        if (s.scene === 'nudo') give('P4', 'P5');
        s.scene = event.scene; s.x = .27;
        s.visited = [...new Set([...s.visited, event.scene])]; break;
      case 'expediente':
      case 'carpeta':
        check(s.scene === 'nudo', 'Estos papeles están en la oficina de Sanz.');
        give(event.type === 'expediente' ? 'P4' : 'P5'); break;
      case 'meet':
        check(s.scene === 'taller' && has(s, 'E0'), 'Berta necesita comprobar el encargo.');
        s.flags.met = true; break;
      case 'copy':
      case 'note':
      case 'explain':
      case 'permission':
        check(s.scene === 'taller' && s.flags.met, 'Iria debe aceptar hablar contigo.');
        if (event.type === 'copy') give('P6');
        if (event.type === 'note') give('P7');
        if (event.type === 'explain') s.flags.explained = true;
        if (event.type === 'permission') s.flags.permission = true;
        break;
      case 'deduce': {
        const pairs = { D1: ['P1', 'P2'], D2: ['P2', 'P4'] };
        const answers = { D1: 'unproven', D2: 'knew' };
        check(pairs[event.id] && has(s, ...pairs[event.id]), 'Faltan pruebas para esta conclusión.');
        check(Array.isArray(event.pair) && event.pair.length === 2 && pairs[event.id].every(id => event.pair.includes(id)), 'Revisa qué documentos sostienen esa afirmación.');
        check(event.answer === answers[event.id], 'La conclusión no se sostiene con esas fechas y estados.');
        s.deductions = [...new Set([...s.deductions, ...(event.id === 'D2' ? ['D1', 'D2'] : ['D1'])])]; break;
      }
      case 'report':
        check(!reportMissing(s), reportMissing(s));
        check(event.money === '300' && event.silence === 'planned' && event.will === 'voluntary', 'Revisa las cantidades, el reparto y la voluntad de Iria.');
        s.flags.report = true; break;
      case 'finish':
        check(s.scene === 'fiebre' && s.flags.report && !reportMissing(s), 'Completa el informe antes de cerrar el caso.');
        s.flags.ended = true; break;
      case 'hint':
        check(['D1', 'D2', 'final'].includes(event.id), 'Ayuda desconocida.');
        s.hints[event.id] = Math.min(3, (s.hints[event.id] || 0) + 1); break;
      case 'conversation':
        check(typeof event.id === 'string' && /^[a-z_]{1,40}$/.test(event.id), 'Conversación desconocida.');
        s.conversations = [...new Set([...s.conversations, event.id])]; break;
      case 'position':
        check(Number.isFinite(event.x), 'Posición inválida.');
        s.x = Math.max(.07, Math.min(.92, event.x)); break;
      default: throw new Error('Acción desconocida.');
    }
    return s;
  }
  function restore(raw) {
    if (!raw) return { state: initial(), valid: false, reason: '' };
    try {
      const v = JSON.parse(raw);
      if (v.version !== 1 || !SCENES.includes(v.scene) || !Number.isFinite(v.x) || !v.flags || typeof v.flags !== 'object') throw Error();
      for (const key of ['docs', 'read', 'deductions', 'visited', 'conversations']) if (!Array.isArray(v[key]) || v[key].length > 100 || v[key].some(x => typeof x !== 'string')) throw Error();
      if (v.docs.some(id => !DOCS.includes(id)) || v.read.some(id => !v.docs.includes(id)) || v.deductions.some(id => !['D1', 'D2'].includes(id)) || v.visited.some(id => !SCENES.includes(id))) throw Error();
      if (FLAGS.some(k => typeof v.flags[k] !== 'boolean')) throw Error();
      const s = initial();
      for (const key of ['docs', 'read', 'deductions', 'visited']) s[key] = [...new Set(v[key])];
      s.conversations = v.conversations.filter(x => /^[a-z_]{1,40}$/.test(x));
      for (const key of FLAGS) s.flags[key] = v.flags[key];
      s.scene = v.scene; s.x = Math.max(.07, Math.min(.92, v.x));
      for (const key of ['D1', 'D2', 'final']) if (Number.isInteger(v.hints?.[key]) && v.hints[key] >= 0 && v.hints[key] <= 3) s.hints[key] = v.hints[key];
      if (!canTravel(s, s.scene) || (s.flags.accepted && !has(s, 'E0')) || (s.flags.met && !has(s, 'E0', 'P5')) || ((s.flags.explained || s.flags.permission) && !s.flags.met)) throw Error();
      if (s.deductions.includes('D1') && !has(s, 'P1', 'P2')) throw Error();
      if (s.deductions.includes('D2') && !has(s, 'P2', 'P4')) throw Error();
      if ((s.flags.report || s.flags.ended) && reportMissing(s)) throw Error();
      if (s.flags.ended && !s.flags.report) throw Error();
      return { state: s, valid: true, reason: '' };
    } catch { return { state: initial(), valid: false, reason: 'El guardado no es compatible o está incompleto. Puedes comenzar una partida nueva.' }; }
  }
  function objective(s) {
    if (s.flags.ended) return 'Caso cerrado. Iria decide cómo seguir.';
    if (!s.flags.accepted) return 'Habla con la mujer que lleva el libro de la Nómina.';
    if (!has(s, 'P1', 'P3')) return 'Revisa los papeles que Iria dejó en su casillero.';
    if (!s.read.includes('P1')) return 'Lee el justificante para localizar la oficina del gestor.';
    if (!has(s, 'P4', 'P5')) return 'Pide a Sanz el expediente y pregunta por la última visita de Iria.';
    if (!s.read.includes('P5')) return 'Revisa el resguardo de la carpeta que dejó Iria.';
    if (!s.flags.met) return 'Visita el taller y explica a Berta quién paga la búsqueda.';
    if (!has(s, 'P6', 'P7')) return 'Escucha a Iria y examina las copias que conserva.';
    if (!s.flags.explained) return 'Pregunta a Iria por qué eligió esperar al reparto.';
    if (!s.flags.permission) return 'Acuerda con Iria qué ayuda acepta.';
    if (!s.deductions.includes('D2')) return 'Contrasta la confirmación de Sanz con su expediente.';
    if (!s.flags.report) return 'Prepara el informe en la libreta con las pruebas a la vista.';
    return 'Regresa a la Fiebre y presenta el informe a la jefa.';
  }
  const api = { DOCS, SCENES, initial, reduce, restore, has, canTravel, reportMissing, objective };
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
  else root.ArrecifeEngine = api;
})(globalThis);
