class MicMute < Formula
  desc "One-click microphone mute/unmute for macOS menu bar"
  homepage "https://github.com/bahmetpalanci/mic-mute"
  url "https://github.com/bahmetpalanci/mic-mute/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "9f4d49bdfb1eea26fefcadae06ad0654317282f6e960ca078867da444b0f489a"
  license "MIT"
  head "https://github.com/bahmetpalanci/mic-mute.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["12.0", :build]

  def install
    system "swiftc", "MicMute.swift", "-o", "MicMute", "-framework", "Cocoa", "-O"

    app_dir = prefix/"MicMute.app/Contents"
    (app_dir/"MacOS").mkpath
    (app_dir/"Resources").mkpath
    cp "MicMute", app_dir/"MacOS/MicMute"
    cp "MicMute.app/Contents/Info.plist", app_dir/"Info.plist"
    cp "MicMute.app/Contents/Resources/AppIcon.icns", app_dir/"Resources/AppIcon.icns"

    system "codesign", "--force", "--deep", "--sign", "-", prefix/"MicMute.app"

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
