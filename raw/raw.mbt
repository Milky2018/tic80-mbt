// Raw TIC-80 WebAssembly imports.
//
// The signatures mirror `linkTicAPI` from TIC-80 commit
// `4aba09c98f1e5028b82765be1647677b08d35942`.
// Address arguments are byte offsets in the imported linear memory.

///|
/// Direct `env.btn` import for reading TIC-80 gamepad buttons.
///
/// For IDs 0 through 31, the result is nonzero while that button is held and
/// remains nonzero on every frame until it is released. `id = -1` returns the
/// combined 32-bit button mask. Use `btnp` to detect new presses.
pub fn btn(id : Int) -> Int = "env" "btn"

///|
/// Direct `env.btnp` import for reading newly pressed gamepad buttons.
///
/// The result is nonzero when `id` is pressed in the current frame but was not
/// pressed in the previous frame. `id = -1` checks all buttons. `hold` and
/// `period` are measured in 60 Hz ticks: after `hold` ticks, a held button
/// repeats every `period` ticks. For example, 120 and 6 start repeating after
/// two seconds and then repeat ten times per second. `-1` selects TIC-80's
/// default of no repeat.
pub fn btnp(id : Int, hold : Int, period : Int) -> Int = "env" "btnp"

///|
/// Direct `env.clip` import. Restricts subsequent drawing to the rectangle at
/// `(x, y)` with size `w` by `h`; pixels outside it are not visible. Passing -1
/// for all four arguments restores the entire screen as the drawing viewport.
pub fn clip(x : Int, y : Int, w : Int, h : Int) -> Unit = "env" "clip"

///|
/// Direct `env.cls` import. Clears the entire screen with `color`; the
/// high-level default is palette color 0.
pub fn cls(color : Int) -> Unit = "env" "cls"

///|
/// Direct `env.circ` import. Draws a filled circle of `radius` in `color`,
/// centered at `(x, y)`, using TIC-80's Bresenham rasterizer.
pub fn circ(x : Int, y : Int, radius : Int, color : Int) -> Unit = "env" "circ"

///|
/// Direct `env.circb` import. Draws a one-pixel circle circumference of
/// `radius` in `color`, centered at `(x, y)`, using TIC-80's Bresenham
/// rasterizer.
pub fn circb(x : Int, y : Int, radius : Int, color : Int) -> Unit = "env" "circb"

///|
/// Direct `env.elli` import. Draws a filled ellipse in `color`, centered at
/// `(x, y)` with horizontal and vertical radii `a` and `b`, using TIC-80's
/// Bresenham rasterizer.
pub fn elli(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit = "env" "elli"

///|
/// Direct `env.ellib` import. Draws a one-pixel ellipse border in `color`,
/// centered at `(x, y)` with horizontal and vertical radii `a` and `b`, using
/// TIC-80's Bresenham rasterizer.
pub fn ellib(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit = "env" "ellib"

///|
/// Direct `env.exit` import. Interrupts cartridge execution and returns to the
/// TIC-80 console after the current `TIC` callback ends.
pub fn exit() -> Unit = "env" "exit"

///|
/// Direct `env.fget` import. Returns a nonzero integer when one of a sprite's
/// eight user-defined flags is set. Flag meanings are defined by the cartridge.
pub fn fget(sprite_id : Int, flag : Int) -> Int = "env" "fget"

///|
/// Direct `env.fset` import. Sets or clears one of a sprite's eight user-defined
/// flags. Games may use these flags for properties such as collision, hazards,
/// visibility, or custom drawing behavior.
pub fn fset(sprite_id : Int, flag : Int, value : Bool) -> Unit = "env" "fset"

///|
/// Direct `env.font` import. Draws text with a custom raster font stored in
/// foreground sprites and returns the rendered width.
///
/// `text` must be NUL-terminated. `transparent_colors` must contain at least
/// `color_count` palette indices. `char_width` and `char_height` select glyph
/// dimensions, `fixed` selects fixed-width layout, `scale` enlarges the glyphs,
/// and `alt` selects the alternate 128-character glyph set. TIC-80 replaces -1
/// widths and scale with its 8 by 8, scale-1 defaults.
#unsafe_skip_stub_check
#borrow(text, transparent_colors)
pub fn font(
  text : Bytes,
  x : Int,
  y : Int,
  transparent_colors : Bytes,
  color_count : Int,
  char_width : Int,
  char_height : Int,
  fixed : Bool,
  scale : Int,
  alt : Bool,
) -> Int = "env" "font"

///|
/// Direct `env.key` import. Returns a nonzero integer while `keycode` is held;
/// `keycode = -1` checks whether any keyboard key is held.
pub fn key(keycode : Int) -> Int = "env" "key"

///|
/// Direct `env.keyp` import. Returns a nonzero integer when `keycode` is pressed
/// in the current frame but was not pressed in the previous frame.
///
/// `keycode = -1` checks all keys. `hold` and `period` use the same 60 Hz repeat
/// timing as `btnp`; passing -1 for both disables repeat.
pub fn keyp(keycode : Int, hold : Int, period : Int) -> Int = "env" "keyp"

///|
/// Direct `env.line` import. Draws a straight line in `color` from `(x0, y0)`
/// to `(x1, y1)`.
pub fn line(
  x0 : Float,
  y0 : Float,
  x1 : Float,
  y1 : Float,
  color : Int,
) -> Unit = "env" "line"

///|
/// The field order is the TIC-80 `MapData` ABI: trampoline table index, user
/// data, and result address. `result_buffer` must contain at least 12 bytes: the
/// tile ID is stored at byte 0, with little-endian 32-bit flip and rotation
/// values at offsets 4 and 8. The trampoline is called for each map cell and may
/// update that buffer in place before the tile is drawn.
pub(all) struct MapData {
  trampoline : FuncRef[(Int, Int, Int, FixedArray[Byte]) -> Unit]
  user_data : Int
  result_buffer : FixedArray[Byte]
}

///|
/// Direct `env.map` import. Draws a rectangular tile-map region at a screen
/// position.
///
/// The map contains 8 by 8 pixel cells and can be up to 240 cells wide by 136
/// cells high. `(x, y)` selects its first cell, `(w, h)` its size in cells, and
/// `(sx, sy)` its destination in pixels. `-1` selects TIC-80's defaults of
/// `(x, y) = (0, 0)`, `(w, h) = (30, 17)`, and `scale = 1`.
/// `transparent_colors` must contain at least `color_count` palette indices.
///
/// `map_data` installs an optional per-cell remap callback that can replace,
/// flip, rotate, or hide tiles for this draw without changing map RAM. Map RAM
/// starts at byte address `0x08000`, is row-major, and has a 240-byte row
/// stride.
#unsafe_skip_stub_check
#borrow(transparent_colors, map_data)
pub fn map(
  x : Int,
  y : Int,
  w : Int,
  h : Int,
  sx : Int,
  sy : Int,
  transparent_colors : Bytes,
  color_count : Int,
  scale : Int,
  map_data : MapData?,
) -> Unit = "env" "map"

///|
/// Direct `env.memcpy` import. Copies `length` bytes within TIC-80's 96 KiB RAM
/// from byte address `src` to `dest`; overlapping ranges are supported.
pub fn memcpy(dest : Int, src : Int, length : Int) -> Unit = "env" "memcpy"

///|
/// Direct `env.memset` import. Fills `length` bytes of TIC-80 RAM, beginning at
/// byte `address`, with `value`.
pub fn memset(address : Int, value : Byte, length : Int) -> Unit = "env" "memset"

///|
/// Direct `env.mget` import. Returns the sprite ID stored at map coordinates
/// `(x, y)`.
pub fn mget(x : Int, y : Int) -> Int = "env" "mget"

///|
/// Direct `env.mset` import. Changes the sprite ID at map coordinates `(x, y)`
/// in runtime map RAM. The change normally lasts only while the cartridge is
/// running; use `sync` to save it to a cartridge resource bank.
pub fn mset(x : Int, y : Int, tile_id : Int) -> Unit = "env" "mset"

///|
/// Direct `env.mouse` import. `buffer` must contain at least nine bytes. The
/// host writes little-endian signed 16-bit `x` and `y`, signed 8-bit wheel
/// deltas, then one byte each for the left, middle, and right buttons. A
/// nonzero button byte means pressed.
#unsafe_skip_stub_check
#borrow(buffer)
pub fn mouse(buffer : FixedArray[Byte]) -> Unit = "env" "mouse"

///|
/// Direct `env.music` import. Starts a track created in TIC-80's Music Editor.
///
/// `frame` and `row` select a starting position, `loop_` controls repetition,
/// `sustain` controls notes across frame boundaries, and `tempo` and `speed`
/// override the track settings. `-1` selects stored/default values for those
/// integer options. `track = -1` stops playback.
pub fn music(
  track : Int,
  frame : Int,
  row : Int,
  loop_ : Bool,
  sustain : Bool,
  tempo : Int,
  speed : Int,
) -> Unit = "env" "music"

///|
/// Direct `env.pix` import. A negative `color` returns the palette color at
/// `(x, y)` without changing it; otherwise the pixel is set to `color`.
pub fn pix(x : Int, y : Int, color : Int) -> Byte = "env" "pix"

///|
/// Direct `env.peek` import. Reads a 1-, 2-, 4-, or 8-bit value from TIC-80 RAM.
/// The address is expressed in units of the selected bit width. Use `poke` to
/// write the corresponding memory location.
pub fn peek(address : Int, bits : Int) -> Byte = "env" "peek"

///|
/// Direct `env.peek4` import. Reads a four-bit value using nibble addressing;
/// nibble addresses `2 * n` and `2 * n + 1` select the low and high halves of
/// byte `n`.
pub fn peek4(address : Int) -> Byte = "env" "peek4"

///|
/// Direct `env.peek2` import. Reads a two-bit value using two-bit-field
/// addressing; four consecutive addresses select one byte from least to most
/// significant bits.
pub fn peek2(address : Int) -> Byte = "env" "peek2"

///|
/// Direct `env.peek1` import. Reads one bit using bit addressing; eight
/// consecutive addresses select one byte from least to most significant bit.
pub fn peek1(address : Int) -> Byte = "env" "peek1"

///|
/// Direct `env.pmem` import. `index` must be between 0 and 255. `value = -1L`
/// reads persistent memory; any other value writes it and returns the previous
/// value. Each slot stores an unsigned 32-bit integer and is suitable for small
/// saved values such as high scores or progress. Saves use the cartridge hash
/// unless cartridge metadata supplies a stable `saveid:`.
pub fn pmem(index : Int, value : Int64) -> UInt = "env" "pmem"

///|
/// Direct `env.poke` import. Writes a 1-, 2-, 4-, or 8-bit value to TIC-80 RAM.
/// The address is expressed in units of the selected bit width.
pub fn poke(address : Int, value : Int, bits : Int) -> Unit = "env" "poke"

///|
/// Direct `env.poke4` import. Writes the low four bits of `value` using the
/// nibble addressing described by `peek4`.
pub fn poke4(address : Int, value : Int) -> Unit = "env" "poke4"

///|
/// Direct `env.poke2` import. Writes the low two bits of `value` using the
/// two-bit-field addressing described by `peek2`.
pub fn poke2(address : Int, value : Int) -> Unit = "env" "poke2"

///|
/// Direct `env.poke1` import. Writes the lowest bit of `value` using the bit
/// addressing described by `peek1`.
pub fn poke1(address : Int, value : Int) -> Unit = "env" "poke1"

///|
/// Direct `env.print` import. Draws text with TIC-80's configured font and
/// returns the rendered width.
///
/// `text` must be NUL-terminated. With `fixed = true`, every character occupies
/// an equal-width box; otherwise proportional glyph widths are separated by one
/// pixel. `scale` enlarges the text and `small_font` selects TIC-80's small
/// built-in font.
#unsafe_skip_stub_check
#borrow(text)
pub fn print(
  text : Bytes,
  x : Int,
  y : Int,
  color : Int,
  fixed : Bool,
  scale : Int,
  small_font : Bool,
) -> Int = "env" "print"

///|
/// Direct `env.rect` import. Draws a filled rectangle in `color` at `(x, y)`
/// with size `w` by `h`.
pub fn rect(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit = "env" "rect"

///|
/// Direct `env.rectb` import. Draws a one-pixel rectangle border in `color` at
/// `(x, y)` with size `w` by `h`.
pub fn rectb(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit = "env" "rectb"

///|
/// Direct `env.sfx` import. Plays an effect created in TIC-80's SFX Editor.
///
/// `note` and `octave` identify one of 96 notes, `duration` is measured in 60 Hz
/// ticks with -1 meaning continuous playback, and `channel` selects one of four
/// channels. Left and right volumes range from 0 through 15. Effect speeds range
/// from -4 through 3; the binding-specific sentinel 8 selects the effect's
/// stored speed. `id = -1` stops the selected channel. Invalid channels are
/// ignored, and volume components are truncated to four bits.
pub fn sfx(
  id : Int,
  note : Int,
  octave : Int,
  duration : Int,
  channel : Int,
  volume_left : Int,
  volume_right : Int,
  speed : Int,
) -> Unit = "env" "sfx"

///|
/// Direct `env.spr` import. Draws a sprite, or a rectangular region of sprites,
/// at `(x, y)`.
///
/// `id` selects the top-left sprite; `w` and `h` select the region in sprite
/// units. `scale = 2`, for example, expands an 8 by 8 sprite to 16 by 16 pixels.
/// `flip` values 0 through 3 mean none, horizontal, vertical, and both;
/// `rotate` values 0 through 3 mean clockwise rotations of 0, 90, 180, and 270
/// degrees. `transparent_colors` must contain at least `color_count` palette
/// indices; zero colors draw opaquely.
#unsafe_skip_stub_check
#borrow(transparent_colors)
pub fn spr(
  id : Int,
  x : Int,
  y : Int,
  transparent_colors : Bytes,
  color_count : Int,
  scale : Int,
  flip : Int,
  rotate : Int,
  w : Int,
  h : Int,
) -> Unit = "env" "spr"

///|
/// Direct `env.sync` import. Transfers resource sections between runtime memory
/// and a cartridge bank.
///
/// Mask bits select tiles, sprites, map, sound effects, music, palette, flags,
/// and screen data; a zero mask selects every section. `to_cart = false` loads
/// the bank into runtime memory, while true saves runtime resources into the
/// bank. TIC-80 Pro cartridges provide eight resource banks. Each resource
/// section can be synchronized at most once per frame; later calls may transfer
/// only sections not selected earlier in that frame. This function does not
/// load cartridge code because TIC-80 handles code-bank loading automatically.
pub fn sync(mask : Int, bank : Int, to_cart : Bool) -> Unit = "env" "sync"

///|
/// Direct `env.time` import. Returns milliseconds elapsed since the cartridge
/// began execution, useful for animation and timed events.
pub fn time() -> Float = "env" "time"

///|
/// Direct `env.tstamp` import. Returns seconds since 1970-01-01 00:00:00 UTC,
/// useful for state that evolves between play sessions.
pub fn tstamp() -> UInt = "env" "tstamp"

///|
/// Direct `env.trace` import. `text` must be NUL-terminated; `color = -1`
/// selects palette color 15. This debugging function writes to the TIC-80
/// console; use the console's `cls` command to clear its output.
#unsafe_skip_stub_check
#borrow(text)
pub fn trace(text : Bytes, color : Int) -> Unit = "env" "trace"

///|
/// Direct `env.tri` import. Draws a triangle filled with `color` using the three
/// supplied vertices.
pub fn tri(
  x1 : Float,
  y1 : Float,
  x2 : Float,
  y2 : Float,
  x3 : Float,
  y3 : Float,
  color : Int,
) -> Unit = "env" "tri"

///|
/// Direct `env.trib` import. Draws a one-pixel triangle border in `color` using
/// the three supplied vertices.
pub fn trib(
  x1 : Float,
  y1 : Float,
  x2 : Float,
  y2 : Float,
  x3 : Float,
  y3 : Float,
  color : Int,
) -> Unit = "env" "trib"

///|
/// Direct `env.ttri` import. Draws a texture-mapped triangle from image RAM,
/// map RAM, or the other video bank.
///
/// `(u, v)` values address source pixels rather than sprite IDs; for example,
/// sprite 2 begins at `(16, 0)` in image RAM. `z1`, `z2`, and `z3` provide
/// per-vertex depth for perspective correction, and `depth` enables TIC-80's
/// depth buffer. `transparent_colors` must contain at least `color_count`
/// palette indices.
#unsafe_skip_stub_check
#borrow(transparent_colors)
pub fn ttri(
  x1 : Float,
  y1 : Float,
  x2 : Float,
  y2 : Float,
  x3 : Float,
  y3 : Float,
  u1 : Float,
  v1 : Float,
  u2 : Float,
  v2 : Float,
  u3 : Float,
  v3 : Float,
  texture_source : Int,
  transparent_colors : Bytes,
  color_count : Int,
  z1 : Float,
  z2 : Float,
  z3 : Float,
  depth : Bool,
) -> Unit = "env" "ttri"

///|
/// Direct `env.vbank` import. TIC-80 VRAM contains two 16 KiB banks. Passing 0
/// or 1 selects the target for subsequent drawing and direct VRAM access and
/// returns the previously selected bank; `bank = -1` only queries it.
pub fn vbank(bank : Int) -> Byte = "env" "vbank"
