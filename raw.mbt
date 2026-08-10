// TIC-80 WebAssembly API wrappers.
//
// The signatures mirror `linkTicAPI` from TIC-80 commit
// `4aba09c98f1e5028b82765be1647677b08d35942`.
// Remaining address arguments are byte offsets in the imported linear memory.

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
/// passed directly from `transparent_colors`.
pub fn font(
  text_addr : Int,
  x : Int,
  y : Int,
  transparent_colors? : Bytes = b"",
  char_width? : Int = -1,
  char_height? : Int = -1,
  fixed? : Bool = false,
  scale? : Int = -1,
  alt? : Bool = false,
) -> Int {
  host_font(
    text_addr,
    x,
    y,
    transparent_colors,
    transparent_colors.length(),
    char_width,
    char_height,
    fixed,
    scale,
    alt,
  )
}

///|
#unsafe_skip_stub_check
#borrow(transparent_colors)
fn host_font(
  text_addr : Int,
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
pub(all) struct MouseState {
  x : Int
  y : Int
  scroll_x : Int
  scroll_y : Int
  left : Bool
  middle : Bool
  right : Bool
} derive(Debug, Eq)

///|
/// Returns an independent snapshot of the current mouse state.
pub fn mouse() -> MouseState {
  let buffer = FixedArray::make(9, b'\x00')
  host_mouse(buffer)
  decode_mouse_state(buffer)
}

///|
#unsafe_skip_stub_check
#borrow(buffer)
fn host_mouse(buffer : FixedArray[Byte]) -> Unit = "env" "mouse"

///|
fn decode_mouse_state(buffer : FixedArray[Byte]) -> MouseState {
  {
    x: decode_i16_le(buffer, 0),
    y: decode_i16_le(buffer, 2),
    scroll_x: decode_i8(buffer[4]),
    scroll_y: decode_i8(buffer[5]),
    left: buffer[6] != b'\x00',
    middle: buffer[7] != b'\x00',
    right: buffer[8] != b'\x00',
  }
}

///|
fn decode_i16_le(buffer : FixedArray[Byte], offset : Int) -> Int {
  let bits = buffer[offset].to_int() | (buffer[offset + 1].to_int() << 8)
  if (bits & 0x8000) != 0 {
    bits - 0x10000
  } else {
    bits
  }
}

///|
fn decode_i8(byte : Byte) -> Int {
  let bits = byte.to_int()
  if (bits & 0x80) != 0 {
    bits - 0x100
  } else {
    bits
  }
}

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
/// Transparent colors are passed directly from `transparent_colors`.
pub fn spr(
  id : Int,
  x : Int,
  y : Int,
  transparent_colors? : Bytes = b"",
  scale? : Int = -1,
  flip? : Int = -1,
  rotate? : Int = -1,
  w? : Int = -1,
  h? : Int = -1,
) -> Unit {
  host_spr(
    id,
    x,
    y,
    transparent_colors,
    transparent_colors.length(),
    scale,
    flip,
    rotate,
    w,
    h,
  )
}

///|
#unsafe_skip_stub_check
#borrow(transparent_colors)
fn host_spr(
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
/// Transparent colors are passed directly from `transparent_colors`.
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
  transparent_colors? : Bytes = b"",
  z1? : Float = 0.0,
  z2? : Float = 0.0,
  z3? : Float = 0.0,
  depth? : Bool = false,
) -> Unit {
  host_ttri(
    x1,
    y1,
    x2,
    y2,
    x3,
    y3,
    u1,
    v1,
    u2,
    v2,
    u3,
    v3,
    texture_source,
    transparent_colors,
    transparent_colors.length(),
    z1,
    z2,
    z3,
    depth,
  )
}

///|
#unsafe_skip_stub_check
#borrow(transparent_colors)
fn host_ttri(
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
pub fn vbank(bank : Int) -> Byte = "env" "vbank"
