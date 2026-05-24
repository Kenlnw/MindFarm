# 🌾 MindFarm

A cozy farming simulation game built with LÖVE2D. Tend your farm, buy and sell seeds and crops, and interact with the world around you.

---

## 🎮 How to Play

### Option 1 — Download the build (Recommended)
1. Go to the [Releases](../../releases) page
2. Download the zip for your platform:
   - `MindFarm-windows-vX.X.X.zip` → Windows
   - `MindFarm-mac-vX.X.X.zip` → Mac
   - `MindFarm-linux-vX.X.X.zip` → Linux
3. Extract the zip
4. Run `MindFarm.exe` (Windows) or `MindFarm.app` (Mac)

### Option 2 — Run from source (requires LÖVE 11.5)
1. Install [LÖVE 11.5](https://love2d.org)
2. Clone this repo:
   ```bash
   git clone https://github.com/yourusername/MindFarm.git
   ```
3. Run the game:
   ```bash
   love MindFarm/
   ```

---

## ⌨️ Keybinds

### Movement
| Key | Action |
|-----|--------|
| `W` `A` `S` `D` | Move up / left / down / right |

### Interaction
| Key / Button | Action |
|--------------|--------|
| `Left Click` | Use current tool/item |
| `E` or `Right Click` | Interact with entity (open/close chest, sleep.) |
| `Shift + Left Click` | Quick withdraw / deposit from storage |
| `Esc` | Quit the game (`Y` for Yes, `N` for no) |

### Inventory
| Key / Button | Action |
|--------------|--------|
| `Scroll Wheel` | Cycle through slots |
| `← →` Arrow Keys | Cycle through slots |
| `1` - `5` | Select slot directly |

---

## 🛠️ Built With

- [LÖVE2D](https://love2d.org) — Game framework
- [Simple Tiled Implementation (STI)](https://github.com/karai17/Simple-Tiled-Implementation) — Tilemap library
- [Aseprite](https://www.aseprite.org) — Pixel art & sprites

---

## 📦 Building from Source

Builds are automated via GitHub Actions on every version tag. To trigger a new release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This will automatically build and upload Windows, Mac, and Linux versions to GitHub Releases.
