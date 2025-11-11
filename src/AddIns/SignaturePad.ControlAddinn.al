controladdin "gimSignaturePad"
{
    RequestedHeight = 220;
    RequestedWidth = 420;
    MinimumHeight = 160;
    MinimumWidth = 300;
    VerticalStretch = true;
    HorizontalStretch = true;

    // Wichtig: StartupScript NICHT nochmal in Scripts eintragen!
    Scripts = 'scripts/signaturepad.js';
    StartupScript = 'scripts/startup.js';

    // (keine Events/Procs nötig für den Test)
    // JS -> AL
    event ControlReady();
    event SignatureChanged(Base64NoPrefix: Text);
    event SignatureSubmit(Base64NoPrefix: Text);
    event SignatureCleared();
    event Pong();

    // AL -> JS
    procedure LoadSignature(Base64NoPrefixOrDataUrl: Text);
    procedure GetSignature();
    procedure Clear();
    procedure Ping();
    procedure SetReadOnly(ReadOnly: Boolean); // 👈 neu
    procedure ShowToolbar(Visible: Boolean); // optional, um Viewer-Mode zu bauen
}