# Electric Grid - How To

## Adding Support for a New Electric Pole

Electric Grid now uses a class/tag based connection system instead of a large explicit connection matrix.

Most mod compatibility only requires editing:

```lua
pole_rules.lua
```

---

# Pole Definitions

Poles are registered in:

```lua
pole_rules.poles
```

Example:

```lua
["new-electric-pole"] = {
    class = "distribution",
    tags = { "standard", "modded" },
}
```

---

# Pole Classes

The class determines default connection behavior.

## Distribution

Distribution poles:
- provide local supply area
- connect to transmission poles
- connect to other distribution poles

Example:

```lua
class = "distribution"
```

---

## Transmission

Transmission poles:
- are long-distance power transfer poles
- have their supply area disabled
- connect to other transmission poles
- connect to distribution poles

Example:

```lua
class = "transmission"
```

Most transmission poles automatically receive:

```lua
supply_area_distance = 0
```

during prototype modification.

---

## Utility

Utility poles are special-purpose entities.

These are usually:
- hidden poles
- proxy poles
- scripted poles
- compatibility entities

Example:

```lua
class = "utility"
```

---

# Tags

Tags provide additional semantic grouping.

Example:

```lua
tags = {
    "modded",
    "high-voltage",
    "proxy"
}
```

Tags are currently informational and organizational, but may also be used for future compatibility rules.

---

# Explicit Overrides

Some mods require exceptions that cannot be represented cleanly by classes.

These are handled with:

```lua
pole_rules.explicit_allow
pole_rules.explicit_deny
```

---

## Explicit Allow

Example:

```lua
pole_rules.explicit_allow = {
    ["special-hidden-pole"] = {
        ["big-electric-pole"] = true,
    },
}
```

This forces a connection to be allowed.

---

## Explicit Deny

Example:

```lua
pole_rules.explicit_deny = {
    ["power-combinator-meter-network"] = {
        ["power-combinator-meter-network"] = true,
    },
}
```

This forces a connection to be denied.

Explicit deny takes precedence over normal class behavior.

---

# Recommended Workflow

## Standard Mod Pole

Usually only add:

```lua
["mod-pole"] = {
    class = "distribution",
    tags = { "modded" },
}
```

---

## Long Distance Pole

Use:

```lua
["mod-high-voltage-pole"] = {
    class = "transmission",
    tags = { "high-voltage", "modded" },
}
```

---

## Hidden Or Scripted Pole

Use:

```lua
["mod-hidden-pole"] = {
    class = "utility",
    tags = { "hidden", "scripted" },
}
```

---

# Testing

After adding a pole:

1. Place the pole in-game
2. Test copper wire placement
3. Verify transmission/distribution behavior
4. Verify supply area behavior
5. Check compatibility with underground substations and transformators if applicable

---

# Notes

The old explicit connection matrix system has been removed.

Connection behavior is now generated dynamically from:
- classes
- tags
- explicit overrides

This greatly simplifies mod compatibility maintenance.
