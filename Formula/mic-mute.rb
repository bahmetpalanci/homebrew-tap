class MicMute < Formula
  desc "One-click microphone mute/unmute for macOS menu bar"
  homepage "https://github.com/bahmetpalanci/mic-mute"
  url "https://github.com/bahmetpalanci/mic-mute/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1be4306938473f2d2c0f1e17bb2fc6f43b826a514f2364d6039fdb9e91556881"
  license "MIT"
  head "https://github.com/bahmetpalanci/mic-mute.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["12.0", :build]

  def install
    system "swiftc", "MicMute.swift", "-o", "MicMute",
           "-framework", "Cocoa", "-framework", "CoreAudio", "-O"

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

      Disclaimer:
        This software is provided as-is, without warranty of any kind.
        MicMute is not affiliated with Apple Inc. or any other company.
        It does not collect, transmit, or store any personal data.
    EOS
  end

  test do
    assert_predicate prefix/"MicMute.app/Contents/MacOS/MicMute", :exist?
  end
end
