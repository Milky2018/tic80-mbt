// Raw TIC-80 WebAssembly imports.
//
// The signatures mirror `linkTicAPI` from TIC-80 commit
// `4aba09c98f1e5028b82765be1647677b08d35942`.
// Address arguments are byte offsets in the imported linear memory.

///|
/// Direct `env.btn` import. Returns the current state for `id`; `-1` requests
/// the combined button bitmask.
pub fn raw_btn(id : Int) -> Int = "env" "btn"

///|
/// Direct `env.btnp` import. Reports a new press, or repeats it after `hold`
/// frames every `period` frames. `-1` selects TIC-80's defaults.
pub fn raw_btnp(id : Int, hold : Int, period : Int) -> Int = "env" "btnp"

///|
/// Direct `env.clip` import. Each `-1` argument is replaced by its full-screen
/// default.
pub fn raw_clip(x : Int, y : Int, w : Int, h : Int) -> Unit = "env" "clip"

///|
/// Direct `env.cls` import. Clears the screen with `color`.
pub fn raw_cls(color : Int) -> Unit = "env" "cls"

///|
/// Direct `env.circ` import. Draws a filled circle.
pub fn raw_circ(x : Int, y : Int, radius : Int, color : Int) -> Unit = "env" "circ"

///|
/// Direct `env.circb` import. Draws a circle outline.
pub fn raw_circb(x : Int, y : Int, radius : Int, color : Int) -> Unit = "env" "circb"

///|
/// Direct `env.elli` import. Draws a filled ellipse with semi-axes `a` and `b`.
pub fn raw_elli(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit = "env" "elli"

///|
/// Direct `env.ellib` import. Draws an ellipse outline with semi-axes `a` and
/// `b`.
pub fn raw_ellib(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit = "env" "ellib"

///|
/// Direct `env.exit` import. Returns from the cartridge to the TIC-80 console.
pub fn raw_exit() -> Unit = "env" "exit"

///|
/// Direct `env.fget` import. Returns whether a sprite flag is set as an integer.
pub fn raw_fget(sprite_id : Int, flag : Int) -> Int = "env" "fget"

///|
/// Direct `env.fset` import. Sets or clears a sprite flag.
pub fn raw_fset(sprite_id : Int, flag : Int, value : Bool) -> Unit = "env" "fset"

///|
/// Direct `env.font` import. `text` must be NUL-terminated, and
/// `transparent_colors` must contain at least `color_count` bytes. Returns the
/// rendered text width.
#unsafe_skip_stub_check
#borrow(text, transparent_colors)
pub fn raw_font(
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
/// Direct `env.key` import. Returns the state of `keycode`; `-1` requests any
/// keyboard key.
pub fn raw_key(keycode : Int) -> Int = "env" "key"

///|
/// Direct `env.keyp` import. Reports a new key press, with optional repeat
/// timing. `-1` selects any key or TIC-80's timing defaults.
pub fn raw_keyp(keycode : Int, hold : Int, period : Int) -> Int = "env" "keyp"

///|
/// Direct `env.line` import. Draws a straight line between two points.
pub fn raw_line(
  x0 : Float,
  y0 : Float,
  x1 : Float,
  y1 : Float,
  color : Int,
) -> Unit = "env" "line"

///|
/// The field order is the TIC-80 `MapData` ABI: trampoline table index, user
/// data, and result address. `result_buffer` must contain at least 12 bytes for
/// the remapped tile ID, flip, and rotation values.
pub(all) struct MapData {
  trampoline : FuncRef[(Int, Int, Int, FixedArray[Byte]) -> Unit]
  user_data : Int
  result_buffer : FixedArray[Byte]
}

///|
/// Direct `env.map` import. Draws a map region; `map_data` installs the optional
/// remap callback. `transparent_colors` must contain at least `color_count`
/// bytes. `-1` selects TIC-80's defaults for `x`, `y`, `w`, `h`, and `scale`.
#unsafe_skip_stub_check
#borrow(transparent_colors, map_data)
pub fn raw_map(
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
/// Direct `env.memcpy` import. Copies bytes within TIC-80 RAM.
pub fn raw_memcpy(dest : Int, src : Int, length : Int) -> Unit = "env" "memcpy"

///|
/// Direct `env.memset` import. Fills bytes within TIC-80 RAM.
pub fn raw_memset(address : Int, value : Byte, length : Int) -> Unit = "env" "memset"

///|
/// Direct `env.mget` import. Returns the tile ID at map coordinates `(x, y)`.
pub fn raw_mget(x : Int, y : Int) -> Int = "env" "mget"

///|
/// Direct `env.mset` import. Changes a tile in the runtime map.
pub fn raw_mset(x : Int, y : Int, tile_id : Int) -> Unit = "env" "mset"

///|
/// Direct `env.mouse` import. `buffer` must contain at least nine bytes. The
/// host writes little-endian signed 16-bit `x` and `y`, signed 8-bit wheel
/// deltas, then left, middle, and right buttons.
#unsafe_skip_stub_check
#borrow(buffer)
pub fn raw_mouse(buffer : FixedArray[Byte]) -> Unit = "env" "mouse"

///|
/// Direct `env.music` import. Starts a music track; `track = -1` stops playback.
pub fn raw_music(
  track : Int,
  frame : Int,
  row : Int,
  loop_ : Bool,
  sustain : Bool,
  tempo : Int,
  speed : Int,
) -> Unit = "env" "music"

///|
/// Direct `env.pix` import. A negative `color` reads a pixel; otherwise it
/// writes the pixel. Returns the host's pixel result.
pub fn raw_pix(x : Int, y : Int, color : Int) -> Byte = "env" "pix"

///|
/// Direct `env.peek` import. Reads a 1-, 2-, 4-, or 8-bit value from TIC-80 RAM.
pub fn raw_peek(address : Int, bits : Int) -> Byte = "env" "peek"

///|
/// Direct `env.peek4` import. Reads a four-bit value using nibble addressing.
pub fn raw_peek4(address : Int) -> Byte = "env" "peek4"

///|
/// Direct `env.peek2` import. Reads a two-bit value using two-bit addressing.
pub fn raw_peek2(address : Int) -> Byte = "env" "peek2"

///|
/// Direct `env.peek1` import. Reads a bit using bit addressing.
pub fn raw_peek1(address : Int) -> Byte = "env" "peek1"

///|
/// Direct `env.pmem` import. `index` must be between 0 and 255. `value = -1L`
/// reads persistent memory; any other value writes it and returns the previous
/// value.
pub fn raw_pmem(index : Int, value : Int64) -> UInt = "env" "pmem"

///|
/// Direct `env.poke` import. Writes a 1-, 2-, 4-, or 8-bit value to TIC-80 RAM.
pub fn raw_poke(address : Int, value : Int, bits : Int) -> Unit = "env" "poke"

///|
/// Direct `env.poke4` import. Writes a four-bit value using nibble addressing.
pub fn raw_poke4(address : Int, value : Int) -> Unit = "env" "poke4"

///|
/// Direct `env.poke2` import. Writes a two-bit value using two-bit addressing.
pub fn raw_poke2(address : Int, value : Int) -> Unit = "env" "poke2"

///|
/// Direct `env.poke1` import. Writes a bit using bit addressing.
pub fn raw_poke1(address : Int, value : Int) -> Unit = "env" "poke1"

///|
/// Direct `env.print` import. `text` must be NUL-terminated. Draws the built-in
/// font and returns the rendered width.
#unsafe_skip_stub_check
#borrow(text)
pub fn raw_print(
  text : Bytes,
  x : Int,
  y : Int,
  color : Int,
  fixed : Bool,
  scale : Int,
  small_font : Bool,
) -> Int = "env" "print"

///|
/// Direct `env.rect` import. Draws a filled rectangle.
pub fn raw_rect(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit = "env" "rect"

///|
/// Direct `env.rectb` import. Draws a one-pixel rectangle outline.
pub fn raw_rectb(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit = "env" "rectb"

///|
/// Direct `env.sfx` import. Plays an SFX; `id = -1` stops the selected channel.
/// Invalid channels are ignored, and volume components are truncated to four
/// bits.
pub fn raw_sfx(
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
/// Direct `env.spr` import. Draws one sprite or a rectangular sprite region.
/// `transparent_colors` must contain at least `color_count` bytes.
#unsafe_skip_stub_check
#borrow(transparent_colors)
pub fn raw_spr(
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
/// and a cartridge bank. A zero mask selects every section.
pub fn raw_sync(mask : Int, bank : Int, to_cart : Bool) -> Unit = "env" "sync"

///|
/// Direct `env.time` import. Returns milliseconds elapsed since startup.
pub fn raw_time() -> Float = "env" "time"

///|
/// Direct `env.tstamp` import. Returns the current Unix timestamp in seconds.
pub fn raw_tstamp() -> UInt = "env" "tstamp"

///|
/// Direct `env.trace` import. `text` must be NUL-terminated; `color = -1`
/// selects palette color 15.
#unsafe_skip_stub_check
#borrow(text)
pub fn raw_trace(text : Bytes, color : Int) -> Unit = "env" "trace"

///|
/// Direct `env.tri` import. Draws a filled triangle.
pub fn raw_tri(
  x1 : Float,
  y1 : Float,
  x2 : Float,
  y2 : Float,
  x3 : Float,
  y3 : Float,
  color : Int,
) -> Unit = "env" "tri"

///|
/// Direct `env.trib` import. Draws a triangle outline.
pub fn raw_trib(
  x1 : Float,
  y1 : Float,
  x2 : Float,
  y2 : Float,
  x3 : Float,
  y3 : Float,
  color : Int,
) -> Unit = "env" "trib"

///|
/// Direct `env.ttri` import. Draws a texture-mapped triangle with optional
/// perspective depth and depth buffering. `transparent_colors` must contain at
/// least `color_count` bytes.
#unsafe_skip_stub_check
#borrow(transparent_colors)
pub fn raw_ttri(
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
/// Direct `env.vbank` import. Selects a video bank and returns the previously
/// selected bank; `bank = -1` only queries the current bank.
pub fn raw_vbank(bank : Int) -> Byte = "env" "vbank"
