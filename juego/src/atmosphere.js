// Animated overlays stay inside measured scene regions; documents and people remain unobscured.
window.ArrecifeAtmosphere = (() => {
  const W = 1672, H = 941;
  const settings = {
    fiebre: { rain: [.23,.03,.28,.55], steam: [[.535,.34,.07],[.36,.79,.045]], lights: [[.657,.241,.105,'238,55,107'],[.087,.13,.048,'255,156,55']], bridge: [.25,.415,.19], puddle: [.18,.73,.55], fans: [[.663,.086,.027]] },
    nudo: { rain: [.225,.02,.23,.5], steam: [[.512,.51,.075]], lights: [[.795,.182,.095,'255,183,78']], bridge: [.305,.408,.147], puddle: [.225,.708,.30], fans: [[.506,.262,.022],[.507,.419,.025]], monitor: [.886,.48] },
    taller: { rain: [.262,.02,.12,.47], steam: [[.262,.65,.06],[.39,.81,.035]], lights: [[.698,.253,.08,'255,179,76']], bridge: [.267,.34,.16], puddle: [.06,.712,.36], monitor: [.748,.52] },
    vestuario: { steam: [], lights: [[.073,.3,.08,'255,40,87'],[.588,.215,.054,'255,179,76']], fans: [[.912,.152,.032]], dust: true }
  };
  const fract = n => n - Math.floor(n);
  function glow(ctx, x, y, radius, rgb, alpha) {
    const g = ctx.createRadialGradient(x,y,0,x,y,radius); g.addColorStop(0,`rgba(${rgb},${alpha})`); g.addColorStop(1,`rgba(${rgb},0)`);
    ctx.fillStyle = g; ctx.fillRect(x-radius,y-radius,radius*2,radius*2);
  }
  function draw(ctx, name, t, reduced) {
    if (reduced) return;
    const s = settings[name]; ctx.save();
    for (const [x,y,r,color] of s.lights) { ctx.globalCompositeOperation = 'screen'; glow(ctx,x*W,y*H,r*W,color,.05+.035*(1+Math.sin(t*1.3+x*20))/2); }
    ctx.globalCompositeOperation = 'source-over';
    if (s.rain) {
      const [x,y,w,h] = s.rain; ctx.save(); ctx.beginPath(); ctx.rect(x*W,y*H,w*W,h*H); ctx.clip(); ctx.strokeStyle='#aacbd126'; ctx.lineWidth=1;
      ctx.beginPath(); for(let i=0;i<48;i++){const px=(x+fract(i*.618-t*.009)*w)*W,py=(y+fract(i*.371+t*(.35+fract(i*.13)*.22))*h)*H;ctx.moveTo(px,py);ctx.lineTo(px-3,py+8+ i%6);}ctx.stroke();ctx.restore();
    }
    for(const [x,y,r] of s.steam) for(let i=0;i<7;i++) {
      const p=fract(t*.12+i/7), drift=Math.sin(p*3+i)*r*.24;
      glow(ctx,(x+drift+p*.015)*W,(y-p*r*1.9)*H,(r*.14+p*r*.32)*W,'164,193,200',Math.sin(p*Math.PI)*.065);
    }
    if(s.fans) for(const [x,y,r] of s.fans) {
      ctx.save();ctx.translate(x*W,y*H);ctx.beginPath();ctx.arc(0,0,r*W,0,Math.PI*2);ctx.clip();ctx.rotate(t*2.8);ctx.fillStyle='#96a3a515';
      for(let i=0;i<5;i++){ctx.rotate(Math.PI*2/5);ctx.beginPath();ctx.ellipse(r*W*.48,0,r*W*.43,r*W*.11,.3,0,Math.PI*2);ctx.fill();}ctx.restore();
    }
    if(s.bridge) {
      const [x,y,w]=s.bridge;ctx.save();ctx.beginPath();ctx.rect(x*W,(y-.034)*H,w*W,.035*H);ctx.clip();
      for(let i=0;i<4;i++){const px=(x+fract(t*(i%2 ? -.012:.014)+i*.29)*w)*W,py=y*H, size=9+i%2*3;ctx.fillStyle='#183039cc';ctx.fillRect(px-2,py-size+3,4,size-6);ctx.beginPath();ctx.arc(px,py-size,2,0,7);ctx.fill();ctx.strokeStyle='#183039cc';ctx.lineWidth=2;ctx.beginPath();const stride=Math.sin(t*4+i)*2;ctx.moveTo(px,py-5);ctx.lineTo(px+stride,py);ctx.moveTo(px,py-5);ctx.lineTo(px-stride,py);ctx.stroke();}ctx.restore();
    }
    if(s.puddle){const[x,y,w]=s.puddle;ctx.strokeStyle=name==='fiebre'?'#ef739422':'#dfc29122';ctx.lineWidth=1;for(let i=0;i<9;i++){const p=fract(t*.5+i*.217);ctx.globalAlpha=1-p;ctx.beginPath();ctx.ellipse((x+fract(i*.618)*w)*W,(y+fract(i*.317)*.028)*H,3+p*12,1+p*2,0,0,7);ctx.stroke();}ctx.globalAlpha=1;}
    if(s.monitor){const[x,y]=s.monitor;glow(ctx,x*W,y*H,24,'87,215,195',.025+.035*(1+Math.sin(t*2))/2);}
    if(s.dust){ctx.fillStyle='#ffd09f45';for(let i=0;i<14;i++){const x=(.52+fract(i*.39+t*.009)*.14)*W,y=(.23+fract(i*.17-t*.027)*.38)*H;ctx.fillRect(x,y,1.4,1.4);}}
    ctx.restore();
  }
  return { draw };
})();
