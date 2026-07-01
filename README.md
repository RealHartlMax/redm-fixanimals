# redm-fixanimals

> **Fork** of [kibook/redm-fixanimals](https://github.com/kibook/redm-fixanimals) — original work by kibook.

A RedM resource that fixes a number of issues with playing as an animal ped, and extends animal gameplay with additional features.

---

## Problems fixed

| Problem | Fix |
|---|---|
| Bird and fish peds cannot move at all by default | Control context is forced to `OnMount` |
| Animal control set is very limited; other scripts often don't work | `OnMount` enables nearly the same controls as a mounted human ped |
| First person camera is glitchy and can crash the game on certain animals | First person mode is disabled while playing as an animal |
| Animal and horse peds can hit invisible map/interior barriers | Ped config barrier flags are disabled for animals and restored for humans |
| Only a very limited number of animals can attack | Custom attack system added |

---

## Features

### Control context fix

The control context is forced to `OnMount` whenever the player switches to an animal ped:

```lua
-- 0x2804658EB7D8A50B SET_CONTROL_CONTEXT
SetControlContext(2, `OnMount`)
```

This allows birds to fly, fish to swim, and restores most of the same inputs as a human ped on a mount.

### Animal barrier bypass

The script uses a lightweight 1000 ms client polling loop to detect if the player is currently using a human or animal ped.

- If the player is an animal, barrier-related ped config flags are set to `false`
- If the player switches back to a human ped, those flags are set back to `true`

This avoids invisible barrier collisions for animal gameplay while preserving normal behavior for humans.

### Attack system

Animals that cannot normally attack gain a custom attack via the **attack button** (`INPUT_ATTACK`).  
Attack animations, hit radius, knockback force, and damage are configured per animal model in `config.lua`.

- **Short press** → attack
- Attacks respect PvP rules for other players; NPC damage is applied only by the entity owner

### Carry system

Larger animals can pick up and carry **smaller, dead animal peds** in their mouth.

- **Hold attack button** (`INPUT_ATTACK`, ≥ 600 ms) near a dead animal → pick it up
- **Hold attack button again** → drop it
- Carrying is restricted by size class — an animal can only carry peds of a strictly lower size class:

  | Size class | Examples |
  |---|---|
  | 1 – Tiny | Rabbit, bird, squirrel, frog, rat |
  | 2 – Small | Badger, beaver, raccoon, cat |
  | 3 – Medium | Dog, coyote, deer, boar |
  | 4 – Large | Bear, cougar, wolf, alligator |

- The dead ped is attached to the carrier's jaw bone (`SKEL_Jaw`) and hangs limply
- Only NPC peds can be carried (no player-to-player carry)

### Crouch / prone movement

Pressing the **melee button** (`INPUT_HORSE_MELEE`) toggles crouched movement.  
Only the cougar and panther have a visible difference when crouched.

---

## Configuration (`config.lua`)

| Option | Default | Description |
|---|---|---|
| `Config.AttackTypes` | — | Per-model attack animations, radius, force, and damage |
| `Config.AttackCooldown` | `2000` ms | Cooldown between attacks |
| `Config.BarrierBypassEnabled` | `true` | Enables/disables invisible barrier bypass for animal peds |
| `Config.BarrierPollMs` | `500` ms | Poll interval for ped/barrier checks (lower = more aggressive refresh) |
| `Config.CarryHoldTime` | `600` ms | How long to hold the attack button to grab instead of attack |
| `Config.CarryRadius` | `2.0` m | Maximum distance to grab a dead ped |
| `Config.CarryOffset` | `vector3(0, 0.25, -0.08)` | Attachment offset from the carrier's jaw bone |
| `Config.CarryRotation` | `vector3(0, 0, 0)` | Attachment rotation |
| `Config.AnimalSizes` | — | Size class (1–4) per animal model hash |

---

## Installation

1. Copy the resource folder into your server's `resources` directory.
2. Add `ensure redm-fixanimals` to your `server.cfg`.

