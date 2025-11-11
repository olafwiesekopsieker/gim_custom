(function () {
  let pad;

  function boot() {
    if (pad || !window.controlAddIn || !window.YCSignaturePad) return;
    pad = new window.YCSignaturePad(controlAddIn);
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ControlReady', []);
  }

  if (document.readyState !== 'loading') boot();
  else window.addEventListener('load', boot);

  // AL -> JS
  window.GetSignature = function () {
  if (!pad) return;

  // Signatur als PNG holen
  const dataUrl = pad.toBase64();                // data:image/png;base64,....
  const b64 = dataUrl.split('base64,')[1] || ''; // nur der reine Base64-Body

  // Event in AL feuern
  Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('SignatureSubmit', [b64]);
};
  window.LoadSignature = s => { if (pad) pad.loadBase64Png(s); };
  window.Clear         = () => { if (pad) pad.clear(); };
  window.SetReadOnly   = flag => { if (pad) pad.setDrawingEnabled(!flag); };
  window.SetToolbarVisible = v => { if (pad) pad.setToolbarVisible(!!v); };
})();