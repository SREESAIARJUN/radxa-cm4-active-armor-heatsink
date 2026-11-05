# CNC 6061-T6 Armor Enclosure with Integrated Heatsink for a Radxa CM Module and 55 × 40 mm Carrier

## Read this before cutting metal

I could not verify a datasheet or mechanical drawing for a "Radxa CM4 + Nano Carrier Board (Cycle 2)". The design below is therefore fully parametric. Every component and port coordinate is a placeholder that you must measure with calipers or take from the board's DXF/STEP before machining. Four points need checking:

1. **55 × 40 mm is the CM4 module form factor**, not a typical carrier size. Radxa CM3 (RK3566) and Radxa CM5 (RK3588S) both use this footprint. The CM4-standard mounting holes are 3.5 mm in from each edge, on a 48 × 33 mm pattern. The code uses these values.
2. **Port-height conflict.** If the carrier really is the same 55 × 40 mm size, a stacked module covers the carrier's whole top surface. An RJ45 jack (about 13.5 mm tall) can't fit under a module that sits on a 1.5 mm board-to-board connector. The ports must then be on the carrier's underside, or the carrier overhangs the module. The code handles both cases: each port's Z position is set relative to the carrier's top surface and can be negative.
3. **RK3566 and RK3588 are different modules** with different layouts and power levels (about 2–4 W vs. 6–12 W). Two presets are included. The thermal section shows that the RK3588 needs more than a palm-sized passive heatsink for sustained full load.
4. **The aluminum shell will kill onboard Wi-Fi/BT.** Plan a U.FL to SMA bulkhead (a cutout is provided).

---

## 1. Design archit