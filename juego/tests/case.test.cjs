const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const E = require('../src/engine.js');
function playToReport() {
  let s = E.initial();
  const act = event => { s = E.reduce(s, event); };
  act({type:'accept'}); act({type:'travel',scene:'vestuario'}); act({type:'papers'}); act({type:'read',id:'P1'});
  act({type:'travel',scene:'nudo'}); act({type:'expediente'}); act({type:'carpeta'}); act({type:'read',id:'P5'});
  act({type:'travel',scene:'taller'}); act({type:'meet'}); act({type:'copy'}); act({type:'note'}); act({type:'explain'}); act({type:'permission'});
  for (const id of s.docs) act({type:'read',id});
  act({type:'deduce',id:'D2',pair:['P4','P2'],answer:'knew'});
  return s;
}
test('late deduction, complete case, partial refund and save roundtrip', () => {
  let s = playToReport();
  assert.equal(E.reportMissing(s), ''); assert.deepEqual(s.deductions, ['D1','D2']);
  s = E.reduce(s,{type:'report',money:'300',silence:'planned',will:'voluntary'});
  assert.throws(() => E.reduce(s,{type:'finish'}));
  s = E.reduce(s,{type:'travel',scene:'fiebre'}); s = E.reduce(s,{type:'finish'});
  assert.equal(s.flags.ended,true); assert.deepEqual(E.restore(JSON.stringify(s)).state,s);
});
test('wrong evidence and wrong answer do not mutate state', () => {
  const s = playToReport(), original = JSON.stringify(s);
  assert.throws(() => E.reduce(s,{type:'deduce',id:'D2',pair:['P1','P2'],answer:'knew'}));
  assert.throws(() => E.reduce(s,{type:'deduce',id:'D2',pair:['P4','P2'],answer:'later'}));
  assert.throws(() => E.reduce(s,{type:'report',money:'315',silence:'planned',will:'voluntary'}));
  assert.equal(JSON.stringify(s),original);
});
test('contact, consent and reading are prerequisites', () => {
  assert.throws(() => E.reduce(E.initial(),{type:'permission'}));
  assert.throws(() => E.reduce(E.initial(),{type:'travel',scene:'nudo'}));
  for (const flag of ['met','explained','permission']) {
    const s = playToReport(); s.flags[flag] = false;
    assert.throws(() => E.reduce(s,{type:'report',money:'300',silence:'planned',will:'voluntary'}));
  }
  const s = playToReport(); s.read = s.read.filter(x=>x!=='P6'); assert.notEqual(E.reportMissing(s),'');
});
test('leaving Sanz preserves the documents needed to continue', () => {
  let s = E.initial();
  for(const event of [{type:'accept'},{type:'travel',scene:'vestuario'},{type:'papers'},{type:'read',id:'P1'},{type:'travel',scene:'nudo'},{type:'travel',scene:'fiebre'}]) s = E.reduce(s,event);
  assert.ok(E.has(s,'P4','P5'));
});
test('invalid saves recover without importing unknown data', () => {
  for(const raw of ['null','{}','broken','[]']) assert.equal(E.restore(raw).valid,false);
  const s = playToReport(); s.read.push('P9'); assert.equal(E.restore(JSON.stringify(s)).valid,false);
  const clean = playToReport(); clean.extra = '<script>'; clean.x = 50;
  const restored = E.restore(JSON.stringify(clean)); assert.equal(restored.valid,true); assert.equal(restored.state.x,.92); assert.equal(restored.state.extra,undefined);
});
test('all content references resolve and every art file is present', () => {
  const sandbox = {window:{}};
  for(const file of ['content','evidence']) vm.runInNewContext(fs.readFileSync(`src/${file}.js`,'utf8'),sandbox);
  const c = sandbox.window.ArrecifeContent, evidence = sandbox.window.ArrecifeEvidence;
  assert.equal(Object.keys(evidence).length,8);
  for(const scene of Object.values(c.scenes)) assert.ok(fs.existsSync(`assets/${scene.image}`));
  for(const conversation of Object.values(c.conversations)) {
    assert.ok(conversation.lines.length);
    for(const id of conversation.docs || []) assert.ok(evidence[id]);
  }
  for(const id of E.DOCS) { assert.ok(evidence[id].html.length>100); assert.ok(c.sources[id]); }
  const coda = c.conversations.coda.lines.flat().join(' ');
  assert.match(coda,/Doscientos recibidos. Cien pendientes/);
  assert.match(coda,/consulta a Iria antes de aceptar/);
});
