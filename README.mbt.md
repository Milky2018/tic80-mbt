# Milky2018/tic80-mbt

## Configuring a cartridge package

Every package that builds a TIC-80 WebAssembly cartridge must import this
package, use the `foreign_library` package kind, and configure the WebAssembly
linker to use TIC-80's imported linear memory. Add the following declarations
to the cartridge package's `moon.pkg` file:

```moon.pkg
import {
  "Milky2018/tic80",
}

pkgtype(kind: "foreign_library")

options(
  link: {
    "wasm": {
      "import-memory": { "module": "env", "name": "memory" },
      "heap-start-address": 98304,
    },
  },
)
```

This configuration has four responsibilities:

- `import { "Milky2018/tic80" }` makes the TIC-80 API available through the
  `@tic80` package qualifier.
- `pkgtype(kind: "foreign_library")` builds a library-style WebAssembly module
  whose `#export_name` callbacks can be discovered by TIC-80. The cartridge is
  not a standalone WASI executable and does not define a MoonBit `main` entry
  point.
- `"import-memory": { "module": "env", "name": "memory" }` makes the module
  import the `env.memory` linear memory supplied by TIC-80 instead of defining
  its own memory.
- `"heap-start-address": 98304` reserves the first 96 KiB (`0x18000`) of that
  memory for TIC-80's RAM layout and starts MoonBit heap allocation after it.
  TIC-80 copies VRAM, tiles, sprites, map data, input state, audio state, and
  the rest of its runtime RAM into this region before calling the cartridge.

These settings belong to each cartridge package rather than to the reusable
`Milky2018/tic80` API package itself. Build the cartridge with the WebAssembly
backend, for example:

```bash
moon build --target wasm --release path/to/cartridge
```

## Video banks

TIC-80 provides two 16 KiB video-memory banks, represented by `VideoBank`.
Drawing commands and direct access to VRAM operate on the currently selected
bank. `Bank1` is composited over `Bank0`; pixels matching `Bank1`'s clear color
are transparent and reveal `Bank0` underneath.

Use `vbank()` to query the current drawing target without changing it. Use
`vbank_set()` to select a target; it returns the previously selected bank so a
temporary switch can be restored without assuming which bank was active:

```mbt nocheck
let previous = @tic80.vbank_set(Bank1)
// Drawing here targets Bank1.
@tic80.cls(0)
@tic80.print("overlay", x=8, y=8)
ignore(@tic80.vbank_set(previous))
```

Video banks are available in both the free and Pro editions. They are separate
from the cartridge resource banks addressed by the `bank` argument of
`sync()`: `vbank_set()` changes the active VRAM drawing target, while `sync()`
copies tiles, sprites, maps, audio, palettes, flags, or screen data between a
cartridge resource bank and runtime memory.

## Cartridge callbacks

TIC-80 cartridge callbacks are functions exported by the WebAssembly module
and called by TIC-80. They are the reverse of the functions in the raw API:
the cartridge calls imported TIC-80 APIs such as `cls`, `map`, and `spr`, while
TIC-80 calls these exported lifecycle functions.

The WebAssembly ABI signatures are:

| Callback | WebAssembly signature | Required | Purpose |
| --- | --- | --- | --- |
| `BOOT` | `() -> void` | No | Initialize the cartridge once. |
| `TIC` | `() -> void` | Yes | Update and draw one frame at 60 FPS. |
| `SCN` | `(i32) -> void` | No | Apply per-scanline effects to the 240x136 game area. |
| `BDR` | `(i32) -> void` | No | Apply per-scanline effects to the full 256x144 output, including the border. |
| `MENU` | `(i32) -> void` | No | Handle a custom game-menu selection. |

Export names are case-sensitive. A MoonBit function may use an idiomatic
lowercase name internally, but its `#export_name` must use the uppercase name
expected by TIC-80.

### Lifecycle

The first frame follows this sequence:

```text
load cartridge
  -> initialize the WebAssembly VM
  -> BOOT()
  -> TIC()
  -> BDR(row) and SCN(row) while the frame is presented
```

Subsequent frames call `TIC()` and then the scanline callbacks. `MENU(index)`
is only called when the player selects a custom game-menu item.

### `BOOT()`

`BOOT()` is called once after the WebAssembly VM has been initialized and
before the first call to `TIC()`. It is suitable for one-time state, resource
bank, and palette initialization.

```mbt nocheck
///|
#export_name("BOOT")
pub fn boot() -> Unit {
  // One-time initialization.
}
```

### `TIC()`

`TIC()` is the required main callback. TIC-80 calls it once per frame at 60
FPS. Input handling, game-state updates, and ordinary drawing normally belong
here.

```mbt nocheck
///|
#export_name("TIC")
pub fn tic() -> Unit {
  @tic80.cls(0)
  @tic80.map()
  @tic80.spr(1, 100, 60)
}
```

The cartridge fails to load if its WebAssembly module does not export `TIC`.

### `SCN(row)`

`SCN(row)` is called for each scanline in the 240x136 game area. Its `row`
argument ranges from `0` through `135`.

Use it for raster effects that only affect the game area, such as per-line
palette changes, gradients, water distortion, or horizontal scrolling. The
frame should normally be drawn in `TIC()` first; `SCN()` then adjusts display
state while that frame is presented.

```mbt nocheck
///|
#export_name("SCN")
pub fn scn(row : Int) -> Unit {
  // Adjust palette or screen-offset state for this game-area row.
}
```

### `BDR(row)`

`BDR(row)` is called for every scanline in the complete 256x144 output. Its
`row` argument ranges from `0` through `143`. The complete output consists of
the 240x136 game area plus 8-pixel left and right borders and 4-pixel top and
bottom borders.

Use `SCN()` when an effect should be limited to the game area. Use `BDR()` when
the effect must also control the border or otherwise cover the complete output.
TIC-80 processes `BDR()` before `SCN()` on scanlines where both callbacks
participate, and applies palette changes before presenting the line.

```mbt nocheck
///|
#export_name("BDR")
pub fn bdr(row : Int) -> Unit {
  // Adjust palette or border state for this full-output row.
}
```

### `MENU(index)`

`MENU(index)` handles selections from the cartridge's custom game menu. Menu
items are declared by the `menu` cartridge metadata, for example in a `.wasmp`
project:

```text
-- menu: RESTART MUSIC DIFFICULTY
```

The selected item is passed as a zero-based index:

| Selection | Callback |
| --- | --- |
| `RESTART` | `MENU(0)` |
| `MUSIC` | `MENU(1)` |
| `DIFFICULTY` | `MENU(2)` |

```mbt nocheck
///|
#export_name("MENU")
pub fn menu(index : Int) -> Unit {
  match index {
    0 => restart_game()
    1 => toggle_music()
    _ => ()
  }
}
```

If the cartridge does not declare custom menu items, `MENU()` is not called.

### Minimal callback set

Most cartridges only need `BOOT()` and `TIC()` initially. Add `SCN()`, `BDR()`,
or `MENU()` only when the cartridge uses their corresponding features.
