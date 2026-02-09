class MicMute < Formula
  desc "One-click microphone mute/unmute for macOS menu bar"
  homepage "https://github.com/bahmetpalanci/mic-mute"
  url "https://github.com/bahmetpalanci/mic-mute/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "00a4d246851132a9a8b1963369f91550e386bf18907c63bc26be5cb2fb63dfca"
  license "MIT"
  head "https://github.com/bahmetpalanci/mic-mute.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["12.0", :build]

  def install
    system "swiftc", "MicMute.swift", "-o", "MicMute", "-framework", "Cocoa", "-O"

    app_dir = prefix/"MicMute.app/Contents"
    (app_dir/"MacOS").mkpath
    cp "MicMute", app_dir/"MacOS/MicMute"
    cp "MicMute.app/Contents/Info.plist", app_dir/"Info.plist"

    bin.install_symlink app_dir/"MacOS/MicMute"
  end

  def post_install
    ohai "MicMute installed!"
    ohai "Run with: open #{prefix}/MicMute.app"
  end

  def caveats
    <<~EOS
      To start MicMute:
        open #{prefix}/MicMute.app

      To start automatically on login:
        Copy MicMute.app to /Applications and add it to Login Items,
        or create a LaunchAgent plist.

      Usage:
        Left-click the menu bar icon to toggle mute/unmute
        Right-click for quit menu
    EOS
  end

  test do
    assert_predicate prefix/"MicMute.app/Contents/MacOS/MicMute", :exist?
  end
end
