# Fish Out of Water

A video game about a fish battling autism.

Developed with Drason and Max for Global Game Jam 2026.

## How to Play
The recommended method for Windows is to download [the EXE file](https://github.com/zmm2025/fish-out-of-water/blob/main/docs/fish-out-of-water.exe) and run it locally. However, the game is also hosted online at [ggj2026.zain.build](https://ggj2026.zain.build/).

## Deploying

The repo uses GitHub Actions to export the Godot Web build and deploy to GitHub Pages (see `.github/workflows/deploy-pages.yml`). For CI export to work, **`.godot/uid_cache.bin` must be committed** so Godot can resolve resource UIDs in headless export. If you open the project in the editor and the UID cache changes, commit it before pushing.
