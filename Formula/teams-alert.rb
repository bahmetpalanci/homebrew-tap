class TeamsAlert < Formula
  desc "Custom alert sounds for Microsoft Teams contacts - macOS menu bar app"
  homepage "https://github.com/bahmetpalanci/teams-alert"
  url "https://github.com/bahmetpalanci/teams-alert/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "42d6ed8ffcc995329417c883483783a2f76ca1511ad2d2ab633d2ea760c6a5f8"
  license "MIT"
  head "https://github.com/bahmetpalanci/teams-alert.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "-c", "release"

    app_dir = prefix/"TeamsAlert.app/Contents"
    (app_dir/"MacOS").mkpath
    (app_dir/"Resources").mkpath
    cp ".build/release/TeamsAlert", app_dir/"MacOS/TeamsAlert"
    cp "Sources/TeamsAlert/Resources/Info.plist", app_dir/"Info.plist"

    # Generate app icon
    system "swift", "generate_icon.swift"
    system "iconutil", "-c", "icns", "TeamsAlert.iconset", "-o", "TeamsAlert.icns"
    cp "TeamsAlert.icns", app_dir/"Resources/TeamsAlert.icns"

    system "codesign", "--force", "--deep", "--sign", "-", prefix/"TeamsAlert.app"

    bin.install_symlink app_dir/"MacOS/TeamsAlert"
  end

  def post_install
    ohai "TeamsAlert installed!"
    ohai "Run with: open #{prefix}/TeamsAlert.app"
  end

  def caveats
    <<~EOS
      To start Teams Alert:
        open #{prefix}/TeamsAlert.app

      To start automatically on login:
        Copy TeamsAlert.app to /Applications and add it to Login Items.

      Setup:
        1. Click the bell icon in the menu bar
        2. Go to Settings > Grant Accessibility Permission
        3. Add contacts to Watch List with custom sounds
        4. Press Start to begin monitoring

      How it works:
        Monitors Microsoft Teams log files for new chat notifications.
        Plays a distinct alert sound after a configurable delay (default 3s)
        so you can tell it apart from Teams' own notification sound.
        Sound repeats 3x by default for emphasis.
        No Azure registration or OAuth login required.
    EOS
  end

  test do
    assert_predicate prefix/"TeamsAlert.app/Contents/MacOS/TeamsAlert", :exist?
  end
end
