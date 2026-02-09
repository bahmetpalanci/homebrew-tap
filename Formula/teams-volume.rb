class TeamsVolume < Formula
  desc "Per-app volume control for Microsoft Teams on macOS menu bar"
  homepage "https://github.com/bahmetpalanci/teams-volume"
  url "https://github.com/bahmetpalanci/teams-volume/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e41f4877ea10114d438a8867f7ea7ff49428ff35a0c460db8bb4f3656ec08bb0"
  license "MIT"
  head "https://github.com/bahmetpalanci/teams-volume.git", branch: "main"

  depends_on :macos
  depends_on macos: :sonoma
  depends_on xcode: ["15.0", :build]

  def install
    system "swiftc", "TeamsVolume.swift", "-o", "TeamsVolume",
           "-framework", "Cocoa", "-framework", "CoreAudio",
           "-framework", "AudioToolbox", "-O"

    app_dir = prefix/"TeamsVolume.app/Contents"
    (app_dir/"MacOS").mkpath
    cp "TeamsVolume", app_dir/"MacOS/TeamsVolume"
    cp "TeamsVolume.app/Contents/Info.plist", app_dir/"Info.plist"

    bin.install_symlink app_dir/"MacOS/TeamsVolume"
  end

  def post_install
    ohai "TeamsVolume installed!"
    ohai "Run with: open #{prefix}/TeamsVolume.app"
  end

  def caveats
    <<~EOS
      To start TeamsVolume:
        open #{prefix}/TeamsVolume.app

      To start automatically on login:
        Copy TeamsVolume.app to /Applications and add it to Login Items,
        or create a LaunchAgent plist.

      Requirements:
        macOS 14.2 (Sonoma) or later
        Microsoft Teams must be running for volume control to work

      Usage:
        Left-click the menu bar icon to show volume slider
        Drag slider to adjust Teams volume (0-100%)
        Right-click for quit menu
    EOS
  end

  test do
    assert_predicate prefix/"TeamsVolume.app/Contents/MacOS/TeamsVolume", :exist?
  end
end
