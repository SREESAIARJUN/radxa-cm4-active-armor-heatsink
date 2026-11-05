# Radxa CM4 Active Armor Enclosure (Rev 4.0)

# CNC 6061-T6 Armor Enclosure and Passive Heatsink: Radxa CM4 + Nano Carrier

## 0. Verify before cutting metal

I can't confirm several details of this hardware from your spec, so the design is fully parametric:

| Item | Issue | What to do |
|---|---|---|
| SoC | The request says "RK3566/RK3588". These have different packages and power. RK3566 is about 2–3.5 W. RK3588/RK3588S is about 6–10 W sustained. Check which SoC your Radxa CM4 revision actually uses. | Set `soc_size`, `soc_h`, `P_soc` |
| Board outline | 55 × 40 mm matches the CM-module footprint. A carrier exactly that size means the module stacks on top. | Measure the stack height (B2B connector + module) |
| Hole positions | The defaults assume CM4-style holes: 3.5 mm inset, 48 × 33 mm pitch. | Check against the Radxa DXF or STEP |
| Component XY and heights | All defaults are **placeholders**. | Measure with calipers, or use the vendor STEP file |
| Port positions | All defaults are **placeholders**. | Measure the edge offset and Z of each connector |

**Recommended workflow:** import the Radxa STEP file into FreeCAD, read off the centroids and heights, and paste them into the parameter block. Then 3D-print one test shell in PETG before committing to CNC.

---

## 1. Design architecture

```
        ┌─ fins (1.5 mm, 6.5 mm pitch, 10 mm tall) ─┐
        ███████████████████████████████████████████   ← roof 3.0 mm
        ┃ ▓▓▓▓▓▓      ▓▓▓▓      ▓▓▓▓      [boss]  ┃   ← stepped thermal blocks
        ┃  ▓▓▓▓        ▓▓        ▓▓                ┃     (spreader step + contact step)
        ┃  pad         pad       pad      RJ45     ┃   ← 0.5 mm compressed pad gap
        ┃ [SoC]       [PMIC]    [DDR]    ┌────┐    ┃
  split ┣━━━━━━━━━━━━━ PCB ━━━━━━━━━━━━━━━━━━━━━━━┫
        ┃  pillar                         pillar   ┃   ← bottom plate pillars
        ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ← counterbored M2.5×12 SHCS
```

**Two-piece split at the PCB bottom face:**
- **Top shell (heatsink):** carries the fins, thermal pedestals and threaded M2.5 bosses.
- **Bottom plate:** carries the support pillars.

**Clamping:** the PCB is clamped between the pillars and bosses, so pad compression is set by machined geometry, not screw torque.

**Pad gap:**
- The gap equals `pad_nominal − compression`.
- The default is a 1.0 mm pad compressed by 0.5 mm, giving a 0.5 mm final gap. That is 50% compression, so it needs a soft pad (≤ Shore 00-40, e.g. Laird Tflex 700 / Fujipoly XR-m soft series).
- For stiffer pads, use a 0.75 mm pad compressed by 0.25 mm.

**Machining notes:**
- Material: 6061-T6. Pedestal faces flatness ≤ 0.05 mm, Ra ≤ 1.6 µm.
- Finish: Type II black anodize (ε ≈ 0.85).
- **Mask the pedestal contact faces from anodize.** Anodize adds about 0.5–1 K/W.

---

## 2. OpenSCAD code

```openscad
// =====================================================================
//  Radxa CM4 + Nano Carrier — CNC 6061 Armor Enclosure / Passive Heatsink
//  Units: mm. Origin: PCB bottom-left corner, Z=0 = PCB TOP surface.
//  !!! All component/port coordinates are PLACEHOLDERS — measure first !!!
// =====================================================================
$fn = 48;
part = "assembly";      // "top", "bott