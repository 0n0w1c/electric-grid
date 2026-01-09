# Technical Overview: Transformer Energy Conversion Constants

This document provides a technical explanation of the constants used to configure the Transformer system’s fluid-based energy conversion behavior.  
These constants ensure predictable, stable operation across all power scales while remaining compatible with Factorio’s fluid mechanics.

---

## 1. Fluid Throughput Constraints

Factorio pipes have high throughput capabilities (approximately 4,200 units/s).  
If a high-capacity transformer (e.g., 10 GW) used standard water with a heat capacity of 0.2 kJ/°C, the required fluid flow rate would greatly exceed these limits.

To avoid this limitation, the mod increases the **effective energy density** (heat capacity) of the working fluid.  
The target design requirement is a **constant fluid flow rate of ~26 units/s per MW**, regardless of transformer rating.

This ensures that:
- Fluid flow remains well within pipe throughput limits.
- Scaling the transformer to higher capacities does not create fluid bottlenecks.
- Internal boiler operation remains stable under all load conditions.

---

## 2. Heat Capacity Constant: `HEAT_CAPACITY_PER_MW = 0.25655`

This constant defines the thermal energy stored per unit of fluid per degree of temperature.  
It is tuned to produce the desired 26 units/s flow rate at a 1 MW load.

### 2.1 Temperature Differential

The system operates with:
- Target output temperature: 165°C  
- Ambient temperature: 15°C  

Resulting in a temperature delta:

```
ΔT = 165°C − 15°C = 150°C
```

### 2.2 Energy per Unit of Fluid

Heat capacity per MW:

```
Cp = 0.25655 kJ/°C
```

Energy contained in one unit of fluid:

```
Energy_per_unit = Cp × ΔT
Energy_per_unit = 0.25655 × 150 = 38.4825 kJ
```

### 2.3 Flow Rate

For a 1 MW (1000 kJ/s) load:

```
Flow_rate = 1000 kJ/s ÷ 38.4825 kJ
Flow_rate ≈ 25.986 units/s
```

---

## 3. Generator Effectivity Constant: `STEAM_ENGINE_EFFECTIVITY = 2.3068`

This constant corrects for the difference between the generator’s maximum fluid consumption rate and the actual fluid supplied by the boiler.

### 3.1 Generator Consumption Characteristics

The generator is configured as follows:

```
fluid_usage_per_tick = 1 unit/tick
```

Factorio operates at 60 ticks/s:

```
Max_consumption = 60 units/s
```

However, the boiler supplies ~26 units/s.

### 3.2 Duty Cycle Mismatch

Actual generator fill percentage:

```
Duty_cycle = 26 / 60 ≈ 0.43  (43%)
```

Without correction, the generator would produce only 43% of the intended power output.

### 3.3 Correction Factor Derivation

The correction multiplier aligns generator output with intended rated power:

```
Multiplier = Max_consumption / Actual_supply
Multiplier = 60 / 25.986 ≈ 2.3089
```

The implemented value:

```
STEAM_ENGINE_EFFECTIVITY = 2.3068
```

This value ensures:

- Input and output energy remain equal, through the range of the power ratings.

---

## 4. Summary of Constants

| Constant Name               | Value      | Purpose                                                                 |
|-----------------------------|------------|-------------------------------------------------------------------------|
| `HEAT_CAPACITY_PER_MW`      | 0.25655    | Sets fluid energy density to achieve ~26 units/s per MW throughput.     |
| `STEAM_ENGINE_EFFECTIVITY`  | 2.3068     | Corrects generator output to compensate for reduced fluid flow.         |

Together, these magic constants *just work* with Factorio's fluid mechanics, across the range of power ratings.
