# homebrew-tap

Homebrew formulae for [ThermalForge](https://github.com/ProducerGuy/ThermalForge) — free, open-source fan control for Apple Silicon Macs.

## Install

```bash
brew tap ProducerGuy/tap
brew trust --formula ProducerGuy/tap/thermalforge
brew install thermalforge
sudo thermalforge install
```

## Why is this a separate repo?

Homebrew requires taps to be standalone repositories named `homebrew-<name>`. This repo exists solely because of that requirement. All source code lives in the [ThermalForge repo](https://github.com/ProducerGuy/ThermalForge).
