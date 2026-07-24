---
title: "How PiFinder measures sky quality"
date: 2026-07-24
tags: [astro, pifinder, sqm]
description: "PiFinder's plate-solving camera doubles as a sky-quality meter. The three techniques behind it — and how well it tracks a hand-held SQM-L, with an interactive chart of every test session."
permalink: /pifinder-sqm/index.html
layout: false
templateEngineOverride: false
---
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>How PiFinder measures sky quality</title>
<meta name="description" content="How the PiFinder telescope accessory doubles as a sky-quality meter: background photometry, an airglow colour correction, and star-based cross-checks — validated against a hand-held SQM-L.">
<style>
.viz-root {
  color-scheme: light;
  --page:#f9f9f7; --surface:#fcfcfb; --ink:#0b0b0b; --ink2:#52514e; --muted:#898781;
  --grid:#e1e0d9; --axis:#c3c2b7; --border:rgba(11,11,11,.10);
  --s1:#2a78d6; --s2:#eb6834; --band:rgba(42,120,214,.08);
  --tipbg:#0b0b0b; --tipink:#ffffff;
}
@media (prefers-color-scheme: dark) {
  :root:where(:not([data-theme="light"])) .viz-root {
    color-scheme: dark;
    --page:#0d0d0d; --surface:#1a1a19; --ink:#ffffff; --ink2:#c3c2b7; --muted:#898781;
    --grid:#2c2c2a; --axis:#383835; --border:rgba(255,255,255,.10);
    --s1:#3987e5; --s2:#d95926; --band:rgba(57,135,229,.10);
    --tipbg:#fcfcfb; --tipink:#0b0b0b;
  }
}
:root[data-theme="dark"] .viz-root {
  color-scheme: dark;
  --page:#0d0d0d; --surface:#1a1a19; --ink:#ffffff; --ink2:#c3c2b7; --muted:#898781;
  --grid:#2c2c2a; --axis:#383835; --border:rgba(255,255,255,.10);
  --s1:#3987e5; --s2:#d95926; --band:rgba(57,135,229,.10);
  --tipbg:#fcfcfb; --tipink:#0b0b0b;
}
* { box-sizing:border-box }
html { background:#f9f9f7 }
@media (prefers-color-scheme: dark) { :root:where(:not([data-theme="light"])) { background:#0d0d0d } }
:root[data-theme="dark"] { background:#0d0d0d }
body { margin:0 }
.viz-root { background:var(--page); color:var(--ink);
  font:15px/1.55 system-ui,-apple-system,"Segoe UI",sans-serif; min-height:100vh }
.wrap { max-width:960px; margin:0 auto; padding:36px 22px 64px }
h1 { font-size:26px; line-height:1.2; margin:0 0 6px }
.lede { color:var(--ink2); margin:0 0 30px; max-width:66ch }
h2 { font-size:15px; letter-spacing:.05em; text-transform:uppercase; color:var(--ink2);
  margin:34px 0 12px; padding-bottom:6px; border-bottom:1px solid var(--grid) }
.cards { display:grid; grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); gap:12px }
.card { background:var(--surface); border:1px solid var(--border); border-radius:10px; padding:14px 16px }
.card h3 { margin:0 0 6px; font-size:15px }
.card p { margin:0; font-size:13.5px; color:var(--ink2) }
.tag { display:inline-block; font-size:11px; font-weight:600; letter-spacing:.04em;
  padding:1px 8px; border-radius:99px; border:1px solid var(--border); color:var(--ink2);
  margin-left:6px; vertical-align:2px; white-space:nowrap }
.term { border-bottom:1px dotted var(--muted); cursor:help; position:relative }
.term::after { content:attr(data-tip); position:absolute; left:0; bottom:calc(100% + 7px);
  width:max-content; max-width:250px; background:var(--tipbg); color:var(--tipink);
  font-size:12px; line-height:1.45; font-weight:400; padding:8px 10px; border-radius:8px;
  border:1px solid var(--border); box-shadow:0 4px 14px rgba(0,0,0,.25);
  opacity:0; visibility:hidden; transition:opacity .12s; z-index:5; white-space:normal;
  text-align:left; pointer-events:none }
.term:hover::after, .term:focus-visible::after { opacity:1; visibility:visible }
table { border-collapse:collapse; width:100%; font-size:13.5px;
  background:var(--surface); border:1px solid var(--border); border-radius:10px; overflow:hidden }
th,td { text-align:left; padding:8px 12px; border-bottom:1px solid var(--grid) }
tr:last-child td { border-bottom:none }
th { color:var(--ink2); font-weight:600; font-size:12.5px }
td:first-child { font-weight:600 }
.tiles { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:12px; margin-bottom:14px }
.tile { background:var(--surface); border:1px solid var(--border); border-radius:10px; padding:12px 16px }
.tile .k { font-size:12px; color:var(--ink2) }
.tile .v { font-size:26px; font-weight:650; line-height:1.25 }
.tile .d { font-size:12px; color:var(--muted) }
.chartbox { background:var(--surface); border:1px solid var(--border); border-radius:10px; padding:14px 14px 8px }
.chartbox svg { width:100%; height:auto; display:block }
.legend { display:flex; gap:18px; font-size:12.5px; color:var(--ink2); padding:2px 4px 8px; flex-wrap:wrap }
.legend i { width:9px; height:9px; border-radius:50%; display:inline-block; margin-right:6px }
.tick,.bandlab,.axt,.dlab { font:11px system-ui,-apple-system,"Segoe UI",sans-serif }
.tick { fill:var(--muted); font-variant-numeric:tabular-nums }
.bandlab { fill:var(--muted) }
.axt { fill:var(--ink2); font-size:12px }
.dlab { font-size:12px; font-weight:600 }
.note { font-size:12.5px; color:var(--muted); margin-top:12px; max-width:78ch }
</style></head>
<body><div class="viz-root"><div class="wrap">

<h1>How PiFinder measures sky quality</h1>
<p class="lede">PiFinder finds objects in the night sky by photographing the stars and
recognising the pattern (<span class="term" tabindex="0" data-tip="Recognising the star pattern in a photo to work out exactly where the telescope is pointing.">plate solving</span>). The same camera doubles as a sky-darkness meter:
it continuously reports how dark your sky is on the <span class="term" tabindex="0" data-tip="Sky Quality Meter scale: night-sky darkness in magnitudes per square arcsecond. Higher = darker. A city sky is ~18, an excellent dark site ~21.5.">SQM</span> scale. Three techniques
work together — a pixel-brightness measurement produces the number, a colour trick
corrects it on very dark skies, and star brightnesses act as an independent watchdog.
Readings from a hand-held <span class="term" tabindex="0" data-tip="A popular hand-held sky-darkness meter. We hold one next to PiFinder and use its reading as the ground truth.">SQM-L</span> meter, taken side by side, are the ground truth
everything below is tested against. Dotted words show an explanation when you hover.</p>

<h2>Techniques</h2>
<div class="cards">
  <div class="card"><h3>Background brightness <span class="tag">the published number</span></h3>
  <p>Most pixels in a sky photo contain no stars — just sky. We take the middle
  brightness of those empty pixels, subtract the camera's own <span class="term" tabindex="0" data-tip="The signal a camera records even in total darkness (electronic offset plus heat). It must be subtracted before the sky itself can be measured. Technically: the pedestal, or black level.">electronic glow</span>, and divide by
  how long the shutter was open. A <span class="term" tabindex="0" data-tip="A fixed conversion constant (the zero point) that translates the camera's brightness units into the standard sky-darkness scale.">factory calibration</span> converts the result to the standard scale.
  Readings from the last 15 seconds are combined and published once per second.
  Because no stars are needed, it keeps working under cloud and while the telescope
  moves.</p></div>
  <div class="card"><h3>Airglow correction <span class="tag">dark-sky fix</span></h3>
  <p>Even a perfect night sky glows faintly: the atmosphere emits its own light
  (<span class="term" tabindex="0" data-tip="Faint light the upper atmosphere emits on its own — present even on perfectly clear, moonless nights, and stronger in the near-infrared.">airglow</span>), mostly in the infrared. The imx462 has no <span class="term" tabindex="0" data-tip="A filter that blocks infrared light. The HQ camera has one built in, and the SQM-L's own filter behaves much the same — so both see the sky through nearly the same window.">IR filter</span>, so it sees far more of
  that glow than the hand-held meter does — its dark-sky readings come out too bright.
  Airglow has a tell, though: it registers equally in the camera's red, green and blue
  <span class="term" tabindex="0" data-tip="The grid of red, green and blue filters over the sensor's pixels (the Bayer mosaic) that lets a camera see colour.">colour filters</span>, while ordinary skylight lands mostly in the green pixels. The extra red in
  the background therefore measures the airglow, and we subtract it. The HQ camera
  needs far less of this: its built-in IR filter blocks the airglow the same way the
  SQM-L's filter does.</p></div>
  <div class="card"><h3>Star check <span class="tag">watchdog — not an input</span></h3>
  <p>When <span class="term" tabindex="0" data-tip="Recognising the star pattern in a photo to work out exactly where the telescope is pointing.">plate solving</span> succeeds, we compare how bright each star looks against its
  <span class="term" tabindex="0" data-tip="A database of stars with precisely measured positions and brightnesses, used as the reference for what each star should look like.">star catalogue</span> value. This never feeds the published number directly. It answers a different
  question: <em>is something dimming the view?</em> Stars fading while the sky
  background stays put means cloud — the reading is flagged unreliable and
  self-calibration pauses. If the fading pattern instead looks like dew or dirty
  optics under a clear sky, the measured light-loss is subtracted from the published
  value until the optics recover.</p></div>
</div>

<h2>Cameras</h2>
<table>
<thead><tr><th>Camera</th><th>Type</th><th>Sees infrared?</th><th>Glow reference</th><th>Airglow fix</th><th>Star check</th></tr></thead>
<tbody>
<tr><td>imx462 (“mr2”)</td><td>colour</td><td>yes — no <span class="term" tabindex="0" data-tip="A filter that blocks infrared light. The HQ camera has one built in, and the SQM-L's own filter behaves much the same — so both see the sky through nearly the same window.">IR filter</span></td><td><span class="term" tabindex="0" data-tip="A strip of pixels on the sensor that is covered so no light reaches it — it measures the camera's own glow fresh in every frame. Technically: optical black.">shielded pixels</span>, every frame</td><td>needed — calibrated</td><td>yes</td></tr>
<tr><td>HQ / imx477 (“mr”)</td><td>colour</td><td>no — IR filter built in</td><td>factory value + self-learning</td><td>barely needed</td><td>yes</td></tr>
<tr><td>imx296</td><td>mono</td><td>partially</td><td>factory value + self-learning</td><td>impossible — needs colour</td><td>yes</td></tr>
</tbody>
</table>
<p class="note">The infrared column is the key difference. The HQ camera's IR filter
gives it nearly the same spectral window as the SQM-L reference meter, so its dark-sky
readings stay close without correction; the unfiltered imx462 sees the infrared airglow
in full and relies on the colour-based fix above. A mono camera can't see the colour
signature airglow leaves, so it runs the plain background measurement — the imx296 also
has only a single moonlit reference session behind it and is the least-tested
profile.</p>

<h2>Performance — replay of 53 test sessions</h2>
<div class="tiles">
  <div class="tile"><div class="k">Bright skies (≤ 20 mag)</div>
    <div class="v">0.06 mag</div><div class="d"><span class="term" tabindex="0" data-tip="Mean absolute error: the average size of the disagreement with the reference meter, ignoring direction.">typical error</span>, 21 sessions, fix on</div></div>
  <div class="tile"><div class="k">Dark skies (&gt; 20 mag)</div>
    <div class="v">0.11 mag</div><div class="d"><span class="term" tabindex="0" data-tip="Mean absolute error: the average size of the disagreement with the reference meter, ignoring direction.">typical error</span>, 17 sessions — was 0.91 without the fix</div></div>
  <div class="tile"><div class="k">Evidence base</div>
    <div class="v">1 539 photos</div><div class="d">53 sessions · 3 cameras · all checked against an <span class="term" tabindex="0" data-tip="A popular hand-held sky-darkness meter. We hold one next to PiFinder and use its reading as the ground truth.">SQM-L</span></div></div>
</div>
<div class="chartbox">
  <div class="legend"><span><i style="background:var(--s1)"></i>airglow fix ON (what PiFinder runs)</span>
  <span><i style="background:var(--s2)"></i>airglow fix OFF (uncorrected)</span></div>
  <svg viewBox="0 0 1040 400" role="img" aria-label="Measurement error per test session vs sky darkness, airglow fix on vs off"><rect x="52" y="74.3" width="972" height="40.2" fill="var(--band)"/><text x="1018.0" y="69.3" text-anchor="end" class="bandlab">±0.10 mag</text><line x1="131.9" y1="26" x2="131.9" y2="360" stroke="var(--grid)"/><text x="131.9" y="376" text-anchor="middle" class="tick">18</text><line x1="398.2" y1="26" x2="398.2" y2="360" stroke="var(--grid)"/><text x="398.2" y="376" text-anchor="middle" class="tick">19</text><line x1="664.5" y1="26" x2="664.5" y2="360" stroke="var(--grid)"/><text x="664.5" y="376" text-anchor="middle" class="tick">20</text><line x1="930.8" y1="26" x2="930.8" y2="360" stroke="var(--grid)"/><text x="930.8" y="376" text-anchor="middle" class="tick">21</text><line x1="52" y1="295.6" x2="1024" y2="295.6" stroke="var(--grid)"/><line x1="52" y1="195.0" x2="1024" y2="195.0" stroke="var(--grid)"/><line x1="52" y1="-6.2" x2="1024" y2="-6.2" stroke="var(--grid)"/><text x="44" y="299.6" text-anchor="end" class="tick">-1.0</text><text x="44" y="199.0" text-anchor="end" class="tick">-0.5</text><text x="44" y="98.4" text-anchor="end" class="tick">+0.0</text><line x1="52" y1="94.4" x2="1024" y2="94.4" stroke="var(--axis)" stroke-width="1.5"/><circle cx="217.1" cy="82.2" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260711_233231 · fix OFF · sky 18.32 · error +0.06 mag</title></circle><circle cx="211.8" cy="83.1" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260711_233605 · fix OFF · sky 18.30 · error +0.06 mag</title></circle><circle cx="273.0" cy="82.2" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260712_221646 · fix OFF · sky 18.53 · error +0.06 mag</title></circle><circle cx="334.3" cy="105.1" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260714_232132 · fix OFF · sky 18.76 · error -0.05 mag</title></circle><circle cx="302.3" cy="101.4" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260715_010923 · fix OFF · sky 18.64 · error -0.03 mag</title></circle><circle cx="190.5" cy="104.6" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260715_221406 · fix OFF · sky 18.22 · error -0.05 mag</title></circle><circle cx="185.2" cy="99.8" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260716_234617 · fix OFF · sky 18.20 · error -0.03 mag</title></circle><circle cx="209.1" cy="110.3" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_002231 · fix OFF · sky 18.29 · error -0.08 mag</title></circle><circle cx="198.5" cy="53.8" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_220807 · fix OFF · sky 18.25 · error +0.20 mag</title></circle><circle cx="241.1" cy="63.7" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_221133 · fix OFF · sky 18.41 · error +0.15 mag</title></circle><circle cx="243.7" cy="71.9" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_221252 · fix OFF · sky 18.42 · error +0.11 mag</title></circle><circle cx="278.4" cy="65.8" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_221905 · fix OFF · sky 18.55 · error +0.14 mag</title></circle><circle cx="113.2" cy="75.5" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_222528 · fix OFF · sky 17.93 · error +0.09 mag</title></circle><circle cx="270.4" cy="84.9" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_230540 · fix OFF · sky 18.52 · error +0.05 mag</title></circle><circle cx="110.6" cy="110.1" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_231014 · fix OFF · sky 17.92 · error -0.08 mag</title></circle><circle cx="273.0" cy="74.5" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_231225 · fix OFF · sky 18.53 · error +0.10 mag</title></circle><circle cx="249.1" cy="82.7" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_232144 · fix OFF · sky 18.44 · error +0.06 mag</title></circle><circle cx="177.2" cy="65.4" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_232311 · fix OFF · sky 18.17 · error +0.14 mag</title></circle><circle cx="249.1" cy="77.4" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260717_232855 · fix OFF · sky 18.44 · error +0.08 mag</title></circle><circle cx="270.4" cy="96.4" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260719_232225 · fix OFF · sky 18.52 · error -0.01 mag</title></circle><circle cx="313.0" cy="106.5" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260719_232350 · fix OFF · sky 18.68 · error -0.06 mag</title></circle><circle cx="912.2" cy="330.4" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260720_221749 · fix OFF · sky 20.93 · error -1.17 mag</title></circle><circle cx="872.2" cy="279.9" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260720_223719 · fix OFF · sky 20.78 · error -0.92 mag</title></circle><circle cx="898.8" cy="266.5" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260720_231555 · fix OFF · sky 20.88 · error -0.86 mag</title></circle><circle cx="866.9" cy="328.3" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260721_225256 · fix OFF · sky 20.76 · error -1.16 mag</title></circle><circle cx="888.2" cy="300.1" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260721_232103 · fix OFF · sky 20.84 · error -1.02 mag</title></circle><circle cx="946.8" cy="254.5" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260721_232439 · fix OFF · sky 21.06 · error -0.80 mag</title></circle><circle cx="957.4" cy="263.4" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260721_233525 · fix OFF · sky 21.10 · error -0.84 mag</title></circle><circle cx="906.8" cy="289.7" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260721_234431 · fix OFF · sky 20.91 · error -0.97 mag</title></circle><circle cx="957.4" cy="265.7" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260721_235303 · fix OFF · sky 21.10 · error -0.85 mag</title></circle><circle cx="952.1" cy="255.4" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260721_235351 · fix OFF · sky 21.08 · error -0.80 mag</title></circle><circle cx="928.1" cy="234.1" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260721_235536 · fix OFF · sky 20.99 · error -0.69 mag</title></circle><circle cx="792.3" cy="245.0" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260723_221212 · fix OFF · sky 20.48 · error -0.75 mag</title></circle><circle cx="890.8" cy="274.0" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260723_223644 · fix OFF · sky 20.85 · error -0.89 mag</title></circle><circle cx="882.9" cy="250.5" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260723_224234 · fix OFF · sky 20.82 · error -0.78 mag</title></circle><circle cx="909.5" cy="303.4" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260723_233827 · fix OFF · sky 20.92 · error -1.04 mag</title></circle><circle cx="904.2" cy="290.1" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260723_234317 · fix OFF · sky 20.90 · error -0.97 mag</title></circle><circle cx="906.8" cy="288.5" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"><title>20260723_235616 · fix OFF · sky 20.91 · error -0.96 mag</title></circle><circle cx="217.1" cy="94.2" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260711_233231 · fix ON · sky 18.32 · error +0.00 mag</title></circle><circle cx="211.8" cy="95.2" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260711_233605 · fix ON · sky 18.30 · error -0.00 mag</title></circle><circle cx="273.0" cy="94.3" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260712_221646 · fix ON · sky 18.53 · error +0.00 mag</title></circle><circle cx="334.3" cy="117.2" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260714_232132 · fix ON · sky 18.76 · error -0.11 mag</title></circle><circle cx="302.3" cy="111.2" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260715_010923 · fix ON · sky 18.64 · error -0.08 mag</title></circle><circle cx="190.5" cy="108.0" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260715_221406 · fix ON · sky 18.22 · error -0.07 mag</title></circle><circle cx="185.2" cy="88.7" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260716_234617 · fix ON · sky 18.20 · error +0.03 mag</title></circle><circle cx="209.1" cy="89.7" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_002231 · fix ON · sky 18.29 · error +0.02 mag</title></circle><circle cx="198.5" cy="65.8" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_220807 · fix ON · sky 18.25 · error +0.14 mag</title></circle><circle cx="241.1" cy="75.8" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_221133 · fix ON · sky 18.41 · error +0.09 mag</title></circle><circle cx="243.7" cy="84.0" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_221252 · fix ON · sky 18.42 · error +0.05 mag</title></circle><circle cx="278.4" cy="77.9" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_221905 · fix ON · sky 18.55 · error +0.08 mag</title></circle><circle cx="113.2" cy="74.6" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_222528 · fix ON · sky 17.93 · error +0.10 mag</title></circle><circle cx="270.4" cy="97.0" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_230540 · fix ON · sky 18.52 · error -0.01 mag</title></circle><circle cx="110.6" cy="118.5" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_231014 · fix ON · sky 17.92 · error -0.12 mag</title></circle><circle cx="273.0" cy="86.6" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_231225 · fix ON · sky 18.53 · error +0.04 mag</title></circle><circle cx="249.1" cy="90.6" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_232144 · fix ON · sky 18.44 · error +0.02 mag</title></circle><circle cx="177.2" cy="77.5" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_232311 · fix ON · sky 18.17 · error +0.08 mag</title></circle><circle cx="249.1" cy="86.9" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260717_232855 · fix ON · sky 18.44 · error +0.04 mag</title></circle><circle cx="270.4" cy="108.4" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260719_232225 · fix ON · sky 18.52 · error -0.07 mag</title></circle><circle cx="313.0" cy="107.7" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260719_232350 · fix ON · sky 18.68 · error -0.07 mag</title></circle><circle cx="912.2" cy="94.9" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260720_221749 · fix ON · sky 20.93 · error -0.00 mag</title></circle><circle cx="872.2" cy="118.0" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260720_223719 · fix ON · sky 20.78 · error -0.12 mag</title></circle><circle cx="898.8" cy="73.1" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260720_231555 · fix ON · sky 20.88 · error +0.11 mag</title></circle><circle cx="866.9" cy="148.1" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260721_225256 · fix ON · sky 20.76 · error -0.27 mag</title></circle><circle cx="888.2" cy="122.6" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260721_232103 · fix ON · sky 20.84 · error -0.14 mag</title></circle><circle cx="946.8" cy="101.0" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260721_232439 · fix ON · sky 21.06 · error -0.03 mag</title></circle><circle cx="957.4" cy="114.2" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260721_233525 · fix ON · sky 21.10 · error -0.10 mag</title></circle><circle cx="906.8" cy="62.0" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260721_234431 · fix ON · sky 20.91 · error +0.16 mag</title></circle><circle cx="957.4" cy="53.9" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260721_235303 · fix ON · sky 21.10 · error +0.20 mag</title></circle><circle cx="952.1" cy="132.3" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260721_235351 · fix ON · sky 21.08 · error -0.19 mag</title></circle><circle cx="928.1" cy="87.7" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260721_235536 · fix ON · sky 20.99 · error +0.03 mag</title></circle><circle cx="792.3" cy="107.9" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260723_221212 · fix ON · sky 20.48 · error -0.07 mag</title></circle><circle cx="890.8" cy="108.3" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260723_223644 · fix ON · sky 20.85 · error -0.07 mag</title></circle><circle cx="882.9" cy="116.5" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260723_224234 · fix ON · sky 20.82 · error -0.11 mag</title></circle><circle cx="909.5" cy="111.4" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260723_233827 · fix ON · sky 20.92 · error -0.08 mag</title></circle><circle cx="904.2" cy="96.4" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260723_234317 · fix ON · sky 20.90 · error -0.01 mag</title></circle><circle cx="906.8" cy="119.7" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"><title>20260723_235616 · fix ON · sky 20.91 · error -0.13 mag</title></circle><text x="829.6" y="219.2" class="dlab" fill="var(--s2)">fix OFF</text><text x="677.8" y="66.2" class="dlab" fill="var(--s1)">fix ON</text><text x="538" y="394" text-anchor="middle" class="axt">sky darkness measured by the hand-held reference meter — darker sky →</text><text x="14" y="193" class="axt" transform="rotate(-90 14 193)" text-anchor="middle">PiFinder error (mag)</text></svg>
</div>
<p class="note">Each dot is one test session: PiFinder's reading minus the hand-held
meter's, placed left-to-right by how dark the sky was. On brighter skies the two
versions agree, both inside the ±0.10 band. Past 20&nbsp;mag the uncorrected reading
drifts up to a full magnitude too bright, while the airglow fix holds the error to
roughly ±0.1–0.2&nbsp;mag — which is why the fix is what your PiFinder actually runs.
Hover any dot for its session. Data: July 2026 replay of PiFinder's full calibration archive.</p>

</div></div></body></html>
