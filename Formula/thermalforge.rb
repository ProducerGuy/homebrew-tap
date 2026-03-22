class Thermalforge < Formula
  desc "Fan control for Apple Silicon MacBooks"
  homepage "https://github.com/ProducerGuy/ThermalForge"
  url "https://github.com/ProducerGuy/ThermalForge.git", tag: "v0.1.0"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/thermalforge"
  end

  def post_install
    ohai "To install the background daemon (one-time):"
    ohai "  sudo thermalforge install"
    ohai ""
    ohai "To run the menu bar app:"
    ohai "  ThermalForgeApp is not yet distributed via Homebrew."
    ohai "  Build from source: swift build && .build/debug/ThermalForgeApp"
  end

  test do
    assert_match "Fan control", shell_output("#{bin}/thermalforge --help")
  end
end
