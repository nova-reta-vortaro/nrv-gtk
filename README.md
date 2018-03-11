# La Nova Reta Vortaro, por Linukso

Aplikaĵo por viziti la NRV kun Linukso.

![Ekrankopion](https://github.com/nova-reta-vortaro/nrv-gtk/blob/master/screenshot.png?raw=true)

## Instali (kun Flatpak)

```bash
flatpak remote-add --no-gpg-verify gelez http://flatpak.gelez.xyz
sudo flatpak install gelez xyz.gelez.nrv
```

## Kompili la kodon

```bash
meson build -Dprefix=/usr
cd build
ninja

# Por instali

sudo ninja install
```

# Kompili la Flatpak pako

```bash
flatpak-builder fp-build/ flatpak/xyz.gelez.nrv.json
flatpak build-export repo fp-build/ stable
```