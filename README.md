# kOS-Scripts
Scripts for kOS (Kerbal Operating System), which is an autopilot you script yourself for 'Kerbal Space Program'.

See the kOS documentation: [https://ksp-kos.github.io/KOS_DOC/](https://ksp-kos.github.io/KOS_DOC/)

No warranty.

**Archive Path:** `<KSP Root>/Ships/Script/`

## Setup with GNU Stow

This repository is configured to be deployed via [GNU Stow](https://www.gnu.org/software/stow/).

**Prerequisites:**
- GNU Stow installed
- Kerbal Space Program installed at `~/.steam/steam/steamapps/common/Kerbal Space Program/`

**Installation:**
```bash
# Create target directory if it doesn't exist
mkdir -p "$HOME/.steam/steam/steamapps/common/Kerbal Space Program/Ships/Script"

# Deploy scripts via stow
cd ~/git/kOS-Scripts
stow --target="$HOME/.steam/steam/steamapps/common/Kerbal Space Program/Ships/Script" Script
```

This creates symlinks from `Script/boot/`, `Script/lib/`, and `Script/missions/` to:
```
~/.steam/steam/steamapps/common/Kerbal Space Program/Ships/Script/
```

**Uninstall:**
```bash
cd ~/git/kOS-Scripts
stow -D Script
```

---

![https://xkcd.com/1244/](https://imgs.xkcd.com/comics/six_words.png)
- [https://xkcd.com/1244/](https://xkcd.com/1244/)
