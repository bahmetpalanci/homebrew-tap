class TeamsVolume < Formula
  desc "Per-app volume control for Microsoft Teams on macOS menu bar"
  homepage "https://github.com/bahmetpalanci/teams-volume"
  url "https://github.com/bahmetpalanci/teams-volume/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "4a2de22339fcf83a565621a3b0220211b3b2161f39d5da704a84ee9f09dc3034"
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
    (app_dir/"Resources").mkpath
    cp "TeamsVolume", app_dir/"MacOS/TeamsVolume"
    cp "TeamsVolume.app/Contents/Info.plist", app_dir/"Info.plist"
    cp "TeamsVolume.app/Contents/Resources/AppIcon.icns", app_dir/"Resources/AppIcon.icns"

    system "codesign", "--force", "--deep", "--sign", "-", prefix/"TeamsVolume.app"

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

      First launch - Screen Recording permission:
        macOS will ask for Screen & System Audio Recording permission.
        Go to System Settings > Privacy & Security > Screen & System Audio Recording
        and enable TeamsVolume, then relaunch.

      Requirements:
        macOS 14.2 (Sonoma) or later
        Microsoft Teams must be running for volume control to work

      Usage:
        Left-click the menu bar icon to show volume slider
        Drag slider to adjust Teams volume (0-100%)
        Right-click for quit menu

      Disclaimer:
        This software is provided as-is, without warranty of any kind.
        TeamsVolume is not affiliated with Microsoft Corporation or Apple Inc.
        "Microsoft Teams" is a trademark of Microsoft Corporation.
        When using Bluetooth headsets during calls, macOS may switch to
        the lower-quality HFP codec. This is a macOS/Bluetooth limitation.
        TeamsVolume does not collect, transmit, or store any personal data.
    EOS
  end

  test do
    assert_predicate prefix/"TeamsVolume.app/Contents/MacOS/TeamsVolume", :exist?
  end
end
