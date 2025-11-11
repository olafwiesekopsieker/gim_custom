class YCSignaturePad {
  constructor(host) {
    this.host = host;

    // Container
    const root = document.createElement('div');
    root.style.display = 'flex';
    root.style.flexDirection = 'column';
    root.style.gap = '8px';
    root.style.width = '100%';
    root.style.boxSizing = 'border-box';
    host.appendChild(root);

    // Toolbar (im Control)
    // this.toolbar = document.createElement('div');
    // this.toolbar.style.display = 'flex';
    // this.toolbar.style.gap = '8px';

    // const btnSave = document.createElement('button');
    // btnSave.type = 'button';
    // btnSave.textContent = 'Speichern';
    // btnSave.addEventListener('click', () => {
    //   const dataUrl = this.toBase64(); // 'data:image/png;base64,...'
    //   const b64 = (dataUrl.split('base64,')[1]) || '';
    //   Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('SignatureSubmit', [b64]);
    // });

    // const btnClear = document.createElement('button');
    // btnClear.type = 'button';
    // btnClear.textContent = 'Leeren';
    // btnClear.addEventListener('click', () => this.clear());

    // this.toolbar.appendChild(btnSave);
    // this.toolbar.appendChild(btnClear);

    // Zeichenfläche
    const wrap = document.createElement('div');
    wrap.style.width = '100%';
    wrap.style.height = '220px';
    wrap.style.position = 'relative';

    this.canvas = document.createElement('canvas');
    this.canvas.style.width = '100%';
    this.canvas.style.height = '100%';
    this.canvas.style.display = 'block';
    wrap.appendChild(this.canvas);

    //root.appendChild(this.toolbar);
    root.appendChild(wrap);

    this.ctx = this.canvas.getContext('2d', { willReadFrequently: true });
    this._bind();
    this._resize();
    this._redraw();
    this.setDrawingEnabled(true);

    // optional: auf Resizes reagieren
    if ('ResizeObserver' in window) {
      new ResizeObserver(() => { this._resize(); this._redraw(); }).observe(wrap);
    } else {
      window.addEventListener('resize', () => { this._resize(); this._redraw(); });
    }
  }

  _resize() {
    const ratio = Math.max(1, window.devicePixelRatio || 1);
    const rect  = this.canvas.getBoundingClientRect();
    const w = Math.max(1, Math.floor(rect.width  * ratio));
    const h = Math.max(1, Math.floor(rect.height * ratio));
    if (this.canvas.width !== w || this.canvas.height !== h) {
      this.canvas.width = w;
      this.canvas.height = h;
    }
  }

  setDrawingEnabled(enabled) { this.canvas.style.pointerEvents = enabled ? 'auto' : 'none'; }

  _bind() {
    const c = this.canvas, ctx = this.ctx;
    const pos = e => {
      const r = c.getBoundingClientRect();
      const dpr = Math.max(1, window.devicePixelRatio || 1);
      const x = (('touches' in e ? e.touches[0].clientX : e.clientX) - r.left) * dpr;
      const y = (('touches' in e ? e.touches[0].clientY : e.clientY) - r.top)  * dpr;
      return { x, y };
    };
    const start = e => { if (c.style.pointerEvents === 'none') return; this.drawing = true; this._last = pos(e); e.preventDefault(); };
    const move  = e => {
      if (!this.drawing) return;
      const p = pos(e); const dpr = Math.max(1, window.devicePixelRatio || 1);
      ctx.lineCap = 'round'; ctx.lineJoin = 'round'; ctx.lineWidth = 2 * dpr;
      ctx.beginPath(); ctx.moveTo(this._last.x, this._last.y); ctx.lineTo(p.x, p.y); ctx.stroke();
      this._last = p; e.preventDefault();
    };
    const end = () => { this.drawing = false; this._last = null; };

    c.addEventListener('mousedown', start);
    c.addEventListener('mousemove', move);
    document.addEventListener('mouseup', end);
    c.addEventListener('touchstart', start, { passive:false });
    c.addEventListener('touchmove',  move,  { passive:false });
    document.addEventListener('touchend', end);
  }

  _redraw() {
    const w = this.canvas.width, h = this.canvas.height;
    this.ctx.save(); this.ctx.setTransform(1,0,0,1,0,0);
    this.ctx.clearRect(0,0,w,h); this.ctx.restore();
    this.ctx.strokeStyle = '#99a'; this.ctx.lineWidth = 1;
    this.ctx.strokeRect(0.5, 0.5, w-1, h-1);
  }

  clear() { this._redraw(); }

  toBase64() { return this.canvas.toDataURL('image/png'); } // bei JPEG: 'image/jpeg', 0.85

  loadBase64Png(input) {
    const url = /^data:/i.test(input) ? input : 'data:image/png;base64,' + input;
    const img = new Image();
    img.onload = () => { this._redraw(); this.ctx.drawImage(img, 0, 0, this.canvas.width, this.canvas.height); };
    img.src = url;
  }

  setToolbarVisible(v){ this.toolbar.style.display = v ? 'flex' : 'none'; }
}
window.YCSignaturePad = YCSignaturePad;
