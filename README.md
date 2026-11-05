# Radxa CM4 Active Armor Enclosure (Rev 1.0)

# CNC 6061-T6 Armor Enclosure and Passive Heatsink
### Radxa CM-series Compute Module + 55 × 40 mm Nano Carrier

## 0. Read This First

I can't verify a public mechanical drawing for the "Nano Carrier Board (Cycle 1)". The SoC also differs by module:

* **Radxa CM3** uses the RK3566 (~2–3 W).
* **Radxa CM5** uses the RK3588S (~6–8 W sustained, 10 W+ peak).

The design below is fully parametric. The 55 × 40 mm outline and 4× M2.5 holes follow the CM4 form-factor convention (3.5 mm inset, 48 × 33 mm pattern). The following values are placeholders. **Measure them with calipers or take them from the Radxa DXF/STEP before cutting metal:**

* SoC, LPDDR4 and PMIC X/Y positions and heights
* Port positions
* Board-to-board (B2B) stack height

## 1. Mechanical Architecture

```
        ┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐   ← longitudinal fins (lid, 1 piece)
        ├─┴─┴─┴─┴─┴─┴─┴─┴─┴─┤   ← lid plate 3 mm
        │ ▼SoC  ▼DDR  ▼PMIC  │   ← stepped pedestals (individual heights)
        │ ═══ CM module ═══  │   ← hard-stop bosses land on CM at the 4 holes
        │ ─── carrier ─────  │
        │ ▲              ▲   │   ← floor standoffs (M2.5 tapped)
        └────────────────────┘   ← bottom tub with port cut-outs
```

* **Coaxial clamping:**
  * One M2.5 × 25 screw per corner passes through the lid boss, CM, spacer and carrier, and threads into the floor standoff.
  * The lid bosses are machined to bottom out exactly on the CM top surface. **Pad compression is therefore set by machining tolerance, not screw torque.** That is the only reliable way to hold a 0.5 mm compression.
* **Thermal pad spec:**
  * Pad thickness `pad_t` = 1.0 mm, compressed by 0.5 mm, leaving a 0.5 mm final gap.
  * That is 50 % compression, so use a **soft pad** (Shore 00 ≤ 40, e.g. Gelid GP-Ultimate, Fujipoly XR-e soft grade).
  * For stiffer pads, set `pad_t = 1.5` and keep 0.5 mm compression (33 %).
* **Pedestal heights differ per chip** (the "stepped" requirement). Each one computes from chip height + module stack.

## 2. OpenSCAD Code

```openscad
// =====================================================================
//  Radxa CM + Nano Carrier – CNC 6061-T6 Armor Enclosure / Heatsink
//  Units: mm.   Z = 0 at BOTTOM face of carrier PCB.
//  Render: set PART = "bottom" | "lid" | "assembly"
// =====================================================================
PART = "assembly";
$fn  = 48;

// ---------------- Carrier board ----------------
pcb_l      = 55.0;
pcb_w      = 40.0;
pcb_t      = 1.6;
hole_inset = 3.5;              // CM4-style pattern 48 x 33
hole_clear = 2.75;             // M2.5 clearance
tap_d      = 2.05;             // M2.5 tap drill (or 3.6 for heat-set/helicoil)
bot_clear  = 3.0;              // clearance for bottom-side parts

// ---------------- Compute module stack ----------------
b2b_stack  = 1.5;              // mated B2B connector height (MEASURE: 1.5 or 3.0)
cm_t       = 1.2;              // CM PCB thickness (MEASURE)
cm_top     = pcb_t + b2b_stack + cm_t;

// ---------------- Thermal interface ----------------
pad_