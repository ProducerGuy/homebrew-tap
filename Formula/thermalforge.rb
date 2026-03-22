class Thermalforge < Formula
  desc "Fan control for Apple Silicon MacBooks"
  homepage "https://github.com/ProducerGuy/ThermalForge"
  url "https://github.com/ProducerGuy/ThermalForge.git", tag: "v0.1.0"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on macos: :sonoma

  def install
    # Build both CLI and menu bar app
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Install CLI binary
    bin.install ".build/release/thermalforge"

    # Generate app icon if not present
    unless File.exist?("ThermalForge.icns")
      system "swift", "Scripts/generate-icon.swift"
      system "iconutil", "-c", "icns", "ThermalForge.iconset", "-o", "ThermalForge.icns"
    end

    # Create .app bundle in prefix
    app_dir = prefix/"ThermalForge.app/Contents"
    (app_dir/"MacOS").mkpath
    (app_dir/"Resources").mkpath

    cp ".build/release/ThermalForgeApp", app_dir/"MacOS/ThermalForgeApp"
    cp "ThermalForge.icns", app_dir/"Resources/AppIcon.icns"

    (app_dir/"Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>CFBundleName</key>
          <string>ThermalForge</string>
          <key>CFBundleDisplayName</key>
          <string>ThermalForge</string>
          <key>CFBundleIdentifier</key>
          <string>com.thermalforge.app</string>
          <key>CFBundleVersion</key>
          <string>#{version}</string>
          <key>CFBundleShortVersionString</key>
          <string>#{version}</string>
          <key>CFBundleExecutable</key>
          <string>ThermalForgeApp</string>
          <key>CFBundleIconFile</key>
          <string>AppIcon</string>
          <key>CFBundlePackageType</key>
          <string>APPL</string>
          <key>LSMinimumSystemVersion</key>
          <string>14.0</string>
          <key>LSUIElement</key>
          <true/>
          <key>NSHighResolutionCapable</key>
          <true/>
      </dict>
      </plist>
    PLIST
  end

  def post_install
    # Copy .app to /Applications so it shows in Spotlight/Finder
    app_source = prefix/"ThermalForge.app"
    app_dest = Pathname.new("/Applications/ThermalForge.app")

    if app_source.exist?
      app_dest.rmtree if app_dest.exist?
      cp_r app_source, app_dest
      system "xattr", "-cr", app_dest
      system "mdimport", app_dest
    end

    ohai ""
    ohai "ThermalForge installed!"
    ohai ""
    ohai "One last step — set up the background daemon (one-time):"
    ohai ""
    ohai "  sudo thermalforge install"
    ohai ""
    ohai "Then you're all set:"
    ohai "  • Open from Spotlight: search 'ThermalForge'"
    ohai "  • Open from Finder: Applications > ThermalForge"
    ohai "  • Or from terminal: open /Applications/ThermalForge.app"
    ohai ""
    ohai "Turn on 'Launch at Login' in the menu bar dropdown and it starts automatically."
  end

  def caveats
    <<~EOS
      To finish setup, run once:

        sudo thermalforge install

      This installs the background daemon so the app can control fans without sudo.
    EOS
  end

  test do
    assert_match "Fan control", shell_output("#{bin}/thermalforge --help")
  end
end
