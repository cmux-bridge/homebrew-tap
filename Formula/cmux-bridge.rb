# Installs the bridge that lets an iPhone read and drive cmux on this Mac.
#
# A prebuilt universal binary rather than a source build: the audience has cmux
# and wants their phone to reach it, not a Swift toolchain. Homebrew's own
# service block replaces the hand-written launchd plist the other installers
# carry, which is the main reason this is the better way in on a Mac.
class CmuxBridge < Formula
  desc "Read and drive cmux on your Mac from an iPhone"
  homepage "https://github.com/cmux-bridge/mobile-app"
  url "https://github.com/cmux-bridge/homebrew-tap/releases/download/v0.2.3/cmux-bridge-0.2.3-universal.tar.gz"
  version "0.2.3"
  sha256 "ad45ddf2050470c32bc1c293ef0530b8dc0604774813ba8da85a4a1faf45c59d"
  license "MIT"

  depends_on :macos

  def install
    bin.install "cmux-bridged"
  end

  service do
    run [opt_bin/"cmux-bridged", "--port", "7420"]
    keep_alive true
    run_type :immediate
    log_path var/"log/cmux-bridged.log"
    error_log_path var/"log/cmux-bridged.log"
  end

  def caveats
    <<~EOS
      Start it, and have it start at login:
        brew services start cmux-bridge

      It listens on port 7420. If you already installed the bridge another
      way, stop that one first — two of them cannot hold the same port.

      It relays what cmux exposes, so cmux has to be running, and its Socket
      Control Mode (cmux → Settings → Automation) set to "Automation mode":
      the default admits only processes started inside cmux, and this is a
      service. The log says so if it is refused.

      To pair a
      phone, show a code to scan:
        cmux-bridged --pairing-qr tailscale
        cmux-bridged --pairing-qr lan

      Or read the links and type one in by hand:
        cmux-bridged --print-pairing

      If the macOS firewall is on, it refuses this binary (it is not signed
      with a Developer ID): a phone connects and is cut off at once. Allow
      it — Homebrew cannot, the rule needs administrator rights — and restart:
        sudo #{opt_bin}/cmux-bridged --allow-firewall
        brew services restart cmux-bridge
      The firewall keys on the installed file, so repeat this after an upgrade.

      If something is wrong, the log says what:
        tail -20 #{var}/log/cmux-bridged.log
    EOS
  end

  test do
    assert_match "cmux-bridged", shell_output("#{bin}/cmux-bridged --help")
  end
end
