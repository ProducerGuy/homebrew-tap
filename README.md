# homebrew-tap

Homebrew formulae for [ThermalForge](https://github.com/ProducerGuy/ThermalForge), free Apple fan control, open source, for Apple Silicon Macs (M1, M2, M3, M4, M5, M6): Mac mini, MacBook, MacBook Pro, Mac Studio, iMac.

ThermalForge by [Producer Guy](https://github.com/ProducerGuy)

## Install

```bash
brew tap ProducerGuy/tap
brew trust --formula ProducerGuy/tap/thermalforge
brew install thermalforge
sudo thermalforge install
```

## Upgrade

```bash
brew update && brew upgrade thermalforge && sudo thermalforge install
```

`brew update` refreshes your local copy of this tap so brew sees the newest release. The formula here is kept in sync with [ThermalForge releases](https://github.com/ProducerGuy/ThermalForge/releases) automatically.

## Why is this a separate repo?

Homebrew requires taps to be standalone repositories named `homebrew-<name>`. This repo exists solely because of that requirement. All source code lives in the [ThermalForge repo](https://github.com/ProducerGuy/ThermalForge).
