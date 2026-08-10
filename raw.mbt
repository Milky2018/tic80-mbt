// Raw TIC-80 WebAssembly host imports.
//
// The signatures mirror `linkTicAPI` from TIC-80 commit
// `4aba09c98f1e5028b82765be1647677b08d35942`.
// Pointer arguments are byte offsets in the imported linear memory.

///|
/// Returns the selected button state, or the button bit mask when `id` is -1.
pub fn btn(id? : Int = -1) -> Int = "env" "btn"

///|
pub fn btnp(id? : Int = -1, hold? : Int = -1, period? : Int = -1) -> Bool = "env" "btnp"

///|
pub fn clip(x? : Int = -1, y? : Int = -1, w? : Int = -1, h? : Int = -1) -> Unit = "env" "clip"

///|
pub fn cls(color? : Int = -1) -> Unit = "env" "cls"

///|
pub fn circ(x : Int, y : Int, radius : Int, color : Int) -> Unit = "env" "circ"

///|
pub fn circb(x : Int, y : Int, radius : Int, color : Int) -> Unit = "env" "circb"

///|
pub fn elli(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit = "env" "elli"

///|
pub fn ellib(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit = "env" "ellib"

///|
pub fn exit() -> Unit = "env" "exit"

///|
pub fn fget(id : Int, flag : Int) -> Bool = "env" "fget"

///|
pub fn fset(id : Int, flag : Int, value : Bool) -> Unit = "env" "fset"

///|
/// `text_addr` must point to a null-terminated string. Transparent colors are
/// read from `transparent_colors_addr` for `color_count` bytes.
pub fn font(
  text_addr : Int,
  x : Int,
  y : Int,
  transparent_colors_addr? : Int = 0,
  color_count? : Int = 0,
  char_width? : Int = -1,
  char_height? : Int = -1,
  fixed? : Bool = false,
  scale? : Int = -1,
  alt? : Bool = false,
) -> Int = "env" "font"

///|
pub fn key(keycode? : Int = -1) -> Bool = "env" "key"

///|
pub fn keyp(keycode? : Int = -1, hold? : Int = -1, period? : Int = -1) -> Bool = "env" "keyp"

///|
pub fn line(
  x0 : Float,
  y0 : Float,
  x1 : Float,
  y1 : Float,
  color : Int,
) -> Unit = "env" "line"

///|
/// `map_data_addr` is zero for no remap callback. A non-zero value points to
/// three consecutive i32 fields: table index, user data, and result address.
pub fn map(
  x? : Int = -1,
  y? : Int = -1,
  w? : Int = -1,
  h? : Int = -1,
  sx? : Int = 0,
  sy? : Int = 0,
  transparent_colors_addr? : Int = 0,
  color_count? : Int = 0,
  scale? : Int = -1,
  map_data_addr? : Int = 0,
) -> Unit = "env" "map"

///|
pub fn memcpy(dest : Int, src : Int, length : Int) -> Unit = "env" "memcpy"

///|
pub fn memset(address : Int, value : Int, length : Int) -> Unit = "env" "memset"

///|
pub fn mget(x : Int, y : Int) -> Int = "env" "mget"

///|
pub fn mset(x : Int, y : Int, tile_id : Int) -> Unit = "env" "mset"

///|
/// Writes the current mouse state to `data_addr`. The record uses little-endian
/// i16 values for x/y at offsets 0/2, followed by scroll x/y and left/middle/
/// right button bytes at offsets 4 through 8.
pub fn mouse(data_addr : Int) -> Unit = "env" "mouse"

///|
pub fn music(
  track? : Int = -1,
  frame? : Int = -1,
  row? : Int = -1,
  loop_? : Bool = true,
  sustain? : Bool = false,
  tempo? : Int = -1,
  speed? : Int = -1,
) -> Unit = "env" "music"

///|
/// Draws a pixel, or returns its color when `color` is negative.
pub fn pix(x : Int, y : Int, color? : Int = -1) -> Byte = "env" "pix"

///|
pub fn peek(address : Int, bits? : Int = 8) -> Byte = "env" "peek"

///|
pub fn peek4(address : Int) -> Byte = "env" "peek4"

///|
pub fn peek2(address : Int) -> Byte = "env" "peek2"

///|
pub fn peek1(address : Int) -> Byte = "env" "peek1"

///|
/// Reads persistent memory when `value` is -1, otherwise writes `value` and
/// returns the previous value.
pub fn pmem(index : Int, value? : Int64 = -1L) -> UInt = "env" "pmem"

///|
pub fn poke(address : Int, value : Int, bits? : Int = 8) -> Unit = "env" "poke"

///|
pub fn poke4(address : Int, value : Int) -> Unit = "env" "poke4"

///|
pub fn poke2(address : Int, value : Int) -> Unit = "env" "poke2"

///|
pub fn poke1(address : Int, value : Int) -> Unit = "env" "poke1"

///|
/// `text_addr` must point to a null-terminated string.
pub fn print(
  text_addr : Int,
  x : Int,
  y : Int,
  color? : Int = 15,
  fixed? : Bool = false,
  scale? : Int = 1,
  small_font? : Bool = false,
) -> Int = "env" "print"

///|
pub fn rect(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit = "env" "rect"

///|
pub fn rectb(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit = "env" "rectb"

///|
pub fn sfx(
  id : Int,
  note? : Int = -1,
  octave? : Int = -1,
  duration? : Int = -1,
  channel? : Int = 0,
  volume_left? : Int = 15,
  volume_right? : Int = 15,
  speed? : Int = 0,
) -> Unit = "env" "sfx"

///|
/// Transparent colors are read from `transparent_colors_addr` for
/// `color_count` bytes.
pub fn spr(
  id : Int,
  x : Int,
  y : Int,
  transparent_colors_addr? : Int = 0,
  color_count? : Int = 0,
  scale? : Int = -1,
  flip? : Int = -1,
  rotate? : Int = -1,
  w? : Int = -1,
  h? : Int = -1,
) -> Unit = "env" "spr"

///|
pub fn sync(
  mask? : Int = -1,
  bank? : Int = -1,
  to_cart? : Bool = false,
) -> Unit = "env" "sync"

///|
pub fn time() -> Float = "env" "time"

///|
pub fn tstamp() -> UInt = "env" "tstamp"

///|
/// `text_addr` must point to a null-terminated string.
pub fn trace(text_addr : Int, color? : Int = -1) -> Unit = "env" "trace"

///|
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
/// Transparent colors are read from `transparent_colors_addr` for
/// `color_count` bytes.
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
  texture_source? : Int = 0,
  transparent_colors_addr? : Int = 0,
  color_count? : Int = 0,
  z1? : Float = 0.0,
  z2? : Float = 0.0,
  z3? : Float = 0.0,
  depth? : Bool = false,
) -> Unit = "env" "ttri"

///|
pub fn vbank(bank : Int) -> Byte = "env" "vbank"
