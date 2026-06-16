# Technical Overview: Transformator Energy Conversion Constants

This document explains the constants used by the Electric Grid transformator system. The transformator is implemented as a hidden fluid/heat conversion chain, so its apparent electrical rating depends on several Factorio prototype values working together.

The current constants are derived from a single design target:

```lua
constants.TRANSFORMATOR_RATED_FLUID_RATE = 30
constants.TRANSFORMATOR_INPUT_TEMP = 15
constants.TRANSFORMATOR_OUTPUT_TEMP = 165
constants.TRANSFORMATOR_GENERATOR_DEFAULT_TEMP = 100
```

These produce:

```lua
constants.HEAT_CAPACITY_PER_MW = 0.2222222222222222
constants.STEAM_ENGINE_EFFECTIVITY = 2.3076923076923075
```

The goal is for each transformator tier to consume and produce the correct in-game electrical power while using a predictable internal fluid rate of **30 fluid/s at that tier's rated output**. This is only possible because each tier scales the working-fluid heat capacity by its rating.

---

## 1. Why the constants are derived together

The transformator does not depend on a single magic number. Its behavior depends on the interaction between:

- working fluid heat capacity
- boiler energy consumption
- boiler input and output temperatures
- Factorio 2.0 boiler fluid conversion behavior
- generator fluid consumption
- generator default temperature
- generator effectivity
- generator maximum power output

Changing only `HEAT_CAPACITY_PER_MW` or only `STEAM_ENGINE_EFFECTIVITY` can break the apparent power balance. The two values are intentionally derived from the same temperature model.

---

## 2. Fluid throughput target

The current design target is:

```text
30 fluid/s at rated output for each transformator tier
```

For a 1 MW transformator:

```text
1 MW = 1000 kJ/s
Fluid rate = 30 fluid/s
```

For larger tiers, the fluid rate is **not** intended to scale upward as `rating × 30 fluid/s`. Instead, the working-fluid heat capacity scales with the transformator rating, so the hidden conversion chain can keep the same practical fluid rate while carrying more energy per fluid unit.

That distinction is important. Without rating-scaled heat capacity, the top tiers would require impossible internal fluid rates such as thousands or hundreds of thousands of fluid per second. With rating-scaled heat capacity, each tier targets about the same internal fluid rate at full load:

| Rating | Rating in MW | Scaled heat capacity | Target internal fluid rate at rated output |
|--------|--------------|----------------------|--------------------------------------------|
| 1 MW   | 1            | 0.2222222222 kJ/°C   | 30 fluid/s                                 |
| 5 MW   | 5            | 1.1111111111 kJ/°C   | 30 fluid/s                                 |
| 10 MW  | 10           | 2.2222222222 kJ/°C   | 30 fluid/s                                 |
| 50 MW  | 50           | 11.1111111111 kJ/°C  | 30 fluid/s                                 |
| 100 MW | 100          | 22.2222222222 kJ/°C  | 30 fluid/s                                 |
| 500 MW | 500          | 111.1111111111 kJ/°C | 30 fluid/s                                 |
| 1 GW   | 1000         | 222.2222222222 kJ/°C | 30 fluid/s                                 |
| 5 GW   | 5000         | 1111.1111111111 kJ/°C | 30 fluid/s                                |
| 10 GW  | 10000        | 2222.2222222222 kJ/°C | 30 fluid/s                                |

The transformator uses hidden internal entities, so these rates are calibration values for the internal conversion chain rather than normal player pipe throughput targets.

---

## 3. Boiler-side heat capacity

The boiler-side temperature span is:

```text
input temperature  = 15°C
output temperature = 165°C
ΔT_boiler          = 150°C
```

To make 30 fluid/s carry exactly 1 MW:

```text
heat_capacity = 1000 kJ/s / (30 fluid/s × 150°C)
heat_capacity = 0.2222222222222222 kJ/°C
```

In code:

```lua
constants.HEAT_CAPACITY_PER_MW =
    1000 / (
        constants.TRANSFORMATOR_RATED_FLUID_RATE *
        (constants.TRANSFORMATOR_OUTPUT_TEMP - constants.TRANSFORMATOR_INPUT_TEMP)
    )
```

This value is a **per-MW base value**, not the final fluid heat capacity used by every transformator. Each transformator tier receives its own scaled heat capacity. In `constants.lua`, the code converts the rating to MW and then multiplies by this base value:

```lua
local rating_in_MW = rating_in_watts / 1e6
transformator.heat_capacity = (rating_in_MW * constants.HEAT_CAPACITY_PER_MW) .. "kJ"
```

So a 1 MW transformator uses:

```text
1 × 0.2222222222222222 = 0.2222222222222222 kJ/°C
```

A 10 MW transformator uses:

```text
10 × 0.2222222222222222 = 2.2222222222222223 kJ/°C
```

A 1 GW transformator uses:

```text
1000 × 0.2222222222222222 = 222.22222222222223 kJ/°C
```

This rating-scaled heat capacity is required. If all tiers used the same final heat capacity, larger transformator tiers would not carry proportionally more energy and their in-game consumption/production would be wrong.

---

## 4. Generator-side effectivity

The generator does not use the same effective temperature span as the boiler.

The generator-side usable temperature span is:

```text
generator default temperature = 100°C
fluid output temperature      = 165°C
ΔT_generator                  = 65°C
```

The boiler-side span is 150°C, while the generator-side span is only 65°C. Without compensation, the generator would see less usable thermal energy than the boiler put into the fluid.

The correction factor is therefore:

```text
effectivity = ΔT_boiler / ΔT_generator
effectivity = 150 / 65
effectivity = 2.3076923076923075
```

In code:

```lua
constants.STEAM_ENGINE_EFFECTIVITY =
    (constants.TRANSFORMATOR_OUTPUT_TEMP - constants.TRANSFORMATOR_INPUT_TEMP) /
    (constants.TRANSFORMATOR_OUTPUT_TEMP - constants.TRANSFORMATOR_GENERATOR_DEFAULT_TEMP)
```

This is why the value is greater than 1. It is not intended to create free energy; it compensates for the mismatch between the boiler-side and generator-side temperature ranges.

---

## 5. Factorio 2.0 boiler behavior

Factorio 2.0 changed boiler behavior so boilers can produce a different amount of output fluid than the input fluid consumed. Current boiler behavior can use a 10:1 water-to-steam style conversion.

For this mod, the important point is not the steam ratio itself, but that boiler and generator calibration must respect Factorio's current fluid-energy behavior. The transformator constants are therefore expressed as derived values rather than unexplained literals.

The older constants:

```lua
-- old approximate behavior
HEAT_CAPACITY_PER_MW = 0.25655
STEAM_ENGINE_EFFECTIVITY = 2.3068
```

were tuned around an older effective flow target of about 26 fluid/s per MW. The current constants are cleaner because they make the intended target explicit:

```lua
TRANSFORMATOR_RATED_FLUID_RATE = 30
```

---

## 6. Summary

| Constant | Current value | Meaning |
|----------|---------------|---------|
| `TRANSFORMATOR_RATED_FLUID_RATE` | `30` | Target internal fluid rate at rated output for each transformator tier. This is not multiplied by rating; heat capacity scales by rating instead. |
| `TRANSFORMATOR_INPUT_TEMP` | `15` | Boiler input/baseline temperature. |
| `TRANSFORMATOR_OUTPUT_TEMP` | `165` | Boiler output and generator input temperature. |
| `TRANSFORMATOR_GENERATOR_DEFAULT_TEMP` | `100` | Generator default fluid temperature. |
| `HEAT_CAPACITY_PER_MW` | `0.2222222222222222` | Per-MW heat capacity base. The actual transformator fluid heat capacity is `rating_in_MW × HEAT_CAPACITY_PER_MW`. |
| `STEAM_ENGINE_EFFECTIVITY` | `2.3076923076923075` | Correction for 150°C boiler span versus 65°C generator span. |

Together, these values keep the transformator's electrical input and output aligned across the supported power ratings.
