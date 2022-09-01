
# Akai Fire via haxe

An attempt to build midi platform around Akai Fire MIDI controller with haxe.

End goal is to enable easy construction of custom MIDI interfaces, with the software running by raspberry pi or similar.

Currently in prototype stage.

# Set Up

Fundamentally you need haxe installed and set up, available here - https://haxe.org/download/

You also need grig.midi and it's dependencies installed - https://lib.haxe.org/p/grig.midi/

## Quick Start 

Assuming haxe is set up.

```shell
# install dependencies
haxelib install thx.core
haxelib install tink.core
haxelib install grig.pitch

# install grig.midi
haxelib install grig.midi
```

# Code Tests

Various tests can be run to check code still works.

```shell
haxe test.hxml
```

# Physical Tests

## Fire Test Application

You need a physical akai fire plugged into a usb port.

```shell
# build the code
cd example
haxe build-fire-test.hxml

# run the binary
./bin/cpp/fire-test/FireTest
```

## Troubleshooting MIDI ports

If nothing happens you might need to change the port name or number in `example/src/FireTest.hx`

To get an idea of what these values are you can trace the available MIDI ports.

```shell
# build
haxe build-trace-midi.hxml

# run
./bin/cpp/trace-midi-out/TraceMidiOut
```