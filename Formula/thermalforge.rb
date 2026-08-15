class Thermalforge < Formula
  desc "Fan control for Apple Silicon MacBooks"
  homepage "https://github.com/ProducerGuy/ThermalForge"
  url "https://github.com/ProducerGuy/ThermalForge.git", tag: "v0.1.10"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on macos: :sonoma

  def install
    # Build both CLI and menu bar app
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Generate app icon if not present (build-app needs the .icns)
    unless File.exist?("ThermalForge.icns")
      system "swift", "Scripts/generate-icon.swift"
      system "iconutil", "-c", "icns", "ThermalForge.iconset", "-o", "ThermalForge.icns"
    end

    # Assemble the .app bundle in the keg via the single shared assembler baked
    # into the CLI, so it's identical to the from-source path (version, macOS
    # floor, every field). Must run BEFORE bin.install, which moves
    # .build/release/thermalforge out of .build.
    system ".build/release/thermalforge", "build-app",
           "--binary", ".build/release/ThermalForgeApp",
           "--icon", "ThermalForge.icns",
           "--dest", "#{prefix}/ThermalForge.app"

    # Install CLI binary (moves it out of .build/release)
    bin.install ".build/release/thermalforge"
  end

  def caveats
    <<~EOS
      To finish setup, run once:

        sudo thermalforge install

      That command does two things (both need root, which Homebrew's
      sandboxed post-install can't do):
        1. Installs the background daemon so the app controls fans without sudo.
        2. Copies ThermalForge.app into /Applications.

      When it finishes, open ThermalForge from Spotlight or /Applications,
      then turn on "Launch at Login" in the menu bar dropdown.
    EOS
  end

  test do
    assert_match "Fan control", shell_output("#{bin}/thermalforge --help")
  end
end
