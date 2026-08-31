# cmux-bridge tap

Read and drive [cmux](https://cmux.com) on your Mac from an iPhone.

    brew tap cmux-bridge/tap
    brew trust cmux-bridge/tap
    brew install cmux-bridge
    brew services start cmux-bridge

Homebrew 6 refuses to load a formula from a tap it does not know, so the
`trust` line is required rather than optional — without it the install stops
with "Refusing to load formula ... from untrusted tap".

The bridge runs beside cmux and serves a small API on your own network —
nothing passes through a cloud service. It relays what cmux exposes, so cmux
has to be running too.

If it is not reachable, the log says why:

    tail -20 /opt/homebrew/var/log/cmux-bridged.log

To pair a phone, print the links and enter one of them in the app:

    cmux-bridged --print-pairing

The `tailscale` line keeps working when the network changes; the `lan` lines
are faster at home.

This tap holds a prebuilt universal binary (Apple Silicon and Intel) and the
formula. The iPhone app is not distributed here.
