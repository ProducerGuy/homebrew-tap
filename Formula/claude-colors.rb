class ClaudeColors < Formula
  desc "Customize text colors for Claude Code conversations"
  homepage "https://github.com/ProducerGuy/claude-code-conversation-colors"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ProducerGuy/claude-code-conversation-colors/releases/download/v1.0.0/claude-colors-macos-arm64"
      sha256 "f36789f15a9260dc9d9670c63b376e53081483e97eba8593675a5d7d679e4340"
    else
      url "https://github.com/ProducerGuy/claude-code-conversation-colors/releases/download/v1.0.0/claude-colors-macos-x64"
      sha256 "891c1c3dc63f1e5ef7317d230eb7855e14338b0710fe521e79c44807508d8ce6"
    end
  end

  def install
    binary = Dir["claude-colors-*"].first || "claude-colors"
    bin.install binary => "claude-colors"
  end

  def post_install
    ohai "Claude Colors installed!"
    ohai ""
    ohai "Run 'claude-colors' to pick your colors."
    ohai "After picking colors, open a new terminal tab and start Claude Code."
  end

  test do
    assert_predicate bin/"claude-colors", :executable?
  end
end
