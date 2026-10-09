const {test} = require('node:test');
const assert = require('node:assert/strict');
const M = require('../src/motion.js');
function simulate(seconds, options, dt = 1/60) {
  const motion=M.create(); let x=.2;
  for(let t=0;t<seconds-1e-8;t+=dt) x=M.step(motion,x,{dt,...options}).x;
  return {motion,x};
}
test('running has its own speed and movement accelerates gradually',()=>{
  const m=M.create(); M.step(m,.2,{dt:1/60,intent:1,running:true});
  assert.ok(m.velocity>0&&m.velocity<M.RUN);
  const walk=simulate(1,{intent:1}), run=simulate(1,{intent:1,running:true});
  assert.ok(run.x-walk.x>.09); assert.equal(run.motion.running,true); assert.equal(walk.motion.running,false);
});
test('walking releases gradually and turning first brakes the old direction',()=>{
  const {motion:m,x}=simulate(.4,{intent:1});
  const first=M.step(m,x,{dt:1/60,intent:-1}); assert.ok(first.x>x); assert.equal(m.direction,1);
  let pos=first.x;for(let i=0;i<30;i++)pos=M.step(m,pos,{dt:1/60,intent:-1}).x;
  assert.equal(m.direction,-1);
  for(let i=0;i<30;i++)pos=M.step(m,pos,{dt:1/60}).x;
  assert.equal(m.velocity,0); assert.equal(m.moving,false);
});
test('targets arrive once, exactly, without overshooting in walk and run',()=>{
  for(const running of [false,true])for(const target of [.1,.201,.6,.9]) {
    const m=M.create();let x=.2,arrived=false;
    for(let i=0;i<700&&!arrived;i++) {const r=M.step(m,x,{dt:1/60,target,running});x=r.x;arrived=r.arrived;}
    assert.equal(arrived,true);assert.equal(x,target);assert.equal(m.velocity,0);
  }
});
test('bounds, reduced motion and invalid input are safe',()=>{
  const m=M.create();assert.deepEqual(M.step(m,.2,{dt:.03,target:5,reduced:true}),{x:M.MAX,arrived:true});
  assert.equal(m.moving,false);assert.throws(()=>M.step(m,.2,{dt:NaN}));
  assert.equal(simulate(5,{intent:-1}).x,M.MIN);assert.equal(simulate(5,{intent:1,running:true}).x,M.MAX);
});
test('gait is distance-driven and almost identical at 30 and 60fps',()=>{
  const a=simulate(1,{intent:1},1/30),b=simulate(1,{intent:1},1/60);
  assert.ok(Math.abs(a.x-b.x)<.003); assert.ok(Math.abs(a.motion.phase-b.motion.phase)<.03);
  const phase=a.motion.phase;M.stop(a.motion,true);M.step(a.motion,a.x,{dt:.03});assert.equal(a.motion.phase,phase);assert.ok(a.motion.idle>1.3);
});
test('every animation frame reads inside its PNG and has a finite ground anchor',()=>{
  const fs=require('node:fs'),vm=require('node:vm'),sandbox={window:{}};
  vm.runInNewContext(fs.readFileSync('src/sprites.js','utf8'),sandbox);
  for(const atlas of Object.values(sandbox.window.ArrecifeSprites)) {
    const png=fs.readFileSync(`assets/${atlas.file}`),width=png.readUInt32BE(16),height=png.readUInt32BE(20);
    assert.equal(png[25],6,'Sprites require RGBA transparency');
    const cw=width/atlas.columns,ch=height/atlas.rows,n=atlas.columns*atlas.rows;
    for(const values of [atlas.pivots,atlas.bases,atlas.heights])assert.equal(values.length,n);
    for(let i=0;i<n;i++) {
      const [left,right]=atlas.cuts?.[i]||[0,cw],x=(i%atlas.columns)*cw;
      assert.ok(x+left>=0&&x+right<=width&&right>left);
      assert.ok(atlas.bases[i]>0&&atlas.bases[i]<=ch&&atlas.heights[i]>0);
    }
  }
});
test('environment overlays are finite and reduced motion draws nothing',()=>{
  const fs=require('node:fs'),vm=require('node:vm'),sandbox={window:{}};
  vm.runInNewContext(fs.readFileSync('src/atmosphere.js','utf8'),sandbox);
  let calls=0,depth=0;
  const ctx=new Proxy({}, {get(_,name){return (...args)=>{calls++;for(const n of args)if(typeof n==='number')assert.ok(Number.isFinite(n));if(name==='save')depth++;if(name==='restore')depth--;if(name==='createRadialGradient')return{addColorStop(){}};};},set(){return true;}});
  for(const scene of ['fiebre','nudo','taller','vestuario']) {
    const before=calls;sandbox.window.ArrecifeAtmosphere.draw(ctx,scene,2,true);assert.equal(calls,before);
    for(const t of [0,1,20,10000]) {sandbox.window.ArrecifeAtmosphere.draw(ctx,scene,t,false);assert.equal(depth,0);}
  }
});
