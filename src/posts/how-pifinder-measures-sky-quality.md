---
title: "How PiFinder measures sky quality"
date: 2026-07-24
tags: [astro, pifinder, sqm]
description: "PiFinder's plate-solving camera doubles as a sky-quality meter. A one-page report on the three techniques behind it — and how well it tracks a hand-held SQM-L."
layout: layouts/post.njk
---

PiFinder's camera photographs the sky to figure out where the telescope points. It turns out the same photos hold a continuous measurement of how *dark* your sky is — the SQM value observers use to rate a site.

Three techniques cooperate: a solver-free background-brightness measurement produces the published number, a colour-based airglow correction keeps it honest beyond 20 mag/arcsec², and star photometry acts as a watchdog for clouds and dewed-up optics. Tested against a hand-held SQM-L across 53 calibration sessions, the reading now tracks the reference to roughly ±0.1 mag from city skies to a dark site.

**[Read the full one-page report →](/pifinder-sqm/)** — with an interactive chart of every test session, and hover explanations for the jargon.
