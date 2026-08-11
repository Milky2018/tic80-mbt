// TIC-80 WebAssembly API wrappers.
//
// The signatures mirror `linkTicAPI` from TIC-80 commit
// `4aba09c98f1e5028b82765be1647677b08d35942`.
// Remaining address arguments are byte offsets in the imported linear memory.

///|
/// A button on one of the four TIC-80 gamepads.
///
/// The explicit tags are the button IDs expected by the TIC-80 host ABI.
pub(all) enum Button {
  P1Up = 0
  P1Down = 1
  P1Left = 2
  P1Right = 3
  P1A = 4
  P1B = 5
  P1X = 6
  P1Y = 7
  P2Up = 8
  P2Down = 9
  P2Left = 10
  P2Right = 11
  P2A = 12
  P2B = 13
  P2X = 14
  P2Y = 15
  P3Up = 16
  P3Down = 17
  P3Left = 18
  P3Right = 19
  P3A = 20
  P3B = 21
  P3X = 22
  P3Y = 23
  P4Up = 24
  P4Down = 25
  P4Left = 26
  P4Right = 27
  P4A = 28
  P4B = 29
  P4X = 30
  P4Y = 31
} derive(Debug, Eq)

///|
fn Button::to_int(self : Button) -> Int = "%identity"

///|
/// Returns whether the selected gamepad button is currently held.
pub fn btn(button : Button) -> Bool {
  raw_btn(button.to_int()) != 0
}

///|
/// Returns whether any button on any gamepad is currently held.
pub fn any_btn() -> Bool {
  raw_btn(-1) != 0
}

///|
/// An immutable snapshot of all 32 TIC-80 gamepad buttons.
#valtype
pub struct ButtonState {
  priv bits : UInt
} derive(Debug, Eq)

///|
/// Captures all four gamepads in one host call.
pub fn button_state() -> ButtonState {
  { bits: raw_btn(-1).reinterpret_as_uint() }
}

///|
/// Returns whether the selected button was held in this snapshot.
pub fn ButtonState::held(self : ButtonState, button : Button) -> Bool {
  (self.bits & (1U << button.to_int())) != 0U
}

///|
/// Returns whether this snapshot contains any held button.
pub fn ButtonState::any(self : ButtonState) -> Bool {
  self.bits != 0U
}

///|
fn raw_btn(id : Int) -> Int = "env" "btn"

///|
/// Returns whether a button was newly pressed.
pub fn btnp(button : Button, hold? : Int = -1, period? : Int = -1) -> Bool {
  raw_btnp(button.to_int(), hold, period) != 0
}

///|
/// Returns whether any button was newly pressed.
pub fn any_btnp() -> Bool {
  raw_btnp(-1, -1, -1) != 0
}

///|
fn raw_btnp(id : Int, hold : Int, period : Int) -> Int = "env" "btnp"

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
/// Draws ASCII text with a custom raster font. Panics if `text` contains a
/// non-ASCII code unit. Transparent colors are passed directly from
/// `transparent_colors`.
pub fn font(
  text : StringView,
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
    encode_c_text(text),
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
#borrow(text, transparent_colors)
fn host_font(
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
/// A TIC-80 keyboard key.
///
/// The explicit tags are the key codes expected by the TIC-80 host ABI.
pub(all) enum Key {
  A = 1
  B = 2
  C = 3
  D = 4
  E = 5
  F = 6
  G = 7
  H = 8
  I = 9
  J = 10
  K = 11
  L = 12
  M = 13
  N = 14
  O = 15
  P = 16
  Q = 17
  R = 18
  S = 19
  T = 20
  U = 21
  V = 22
  W = 23
  X = 24
  Y = 25
  Z = 26
  Digit0 = 27
  Digit1 = 28
  Digit2 = 29
  Digit3 = 30
  Digit4 = 31
  Digit5 = 32
  Digit6 = 33
  Digit7 = 34
  Digit8 = 35
  Digit9 = 36
  Minus = 37
  Equals = 38
  LeftBracket = 39
  RightBracket = 40
  Backslash = 41
  Semicolon = 42
  Apostrophe = 43
  Grave = 44
  Comma = 45
  Period = 46
  Slash = 47
  Space = 48
  Tab = 49
  Return = 50
  Backspace = 51
  Delete = 52
  Insert = 53
  PageUp = 54
  PageDown = 55
  Home = 56
  End = 57
  Up = 58
  Down = 59
  Left = 60
  Right = 61
  CapsLock = 62
  Ctrl = 63
  Shift = 64
  Alt = 65
  Escape = 66
  F1 = 67
  F2 = 68
  F3 = 69
  F4 = 70
  F5 = 71
  F6 = 72
  F7 = 73
  F8 = 74
  F9 = 75
  F10 = 76
  F11 = 77
  F12 = 78
  Numpad0 = 79
  Numpad1 = 80
  Numpad2 = 81
  Numpad3 = 82
  Numpad4 = 83
  Numpad5 = 84
  Numpad6 = 85
  Numpad7 = 86
  Numpad8 = 87
  Numpad9 = 88
  NumpadPlus = 89
  NumpadMinus = 90
  NumpadMultiply = 91
  NumpadDivide = 92
  NumpadEnter = 93
  NumpadPeriod = 94
} derive(Debug, Eq)

///|
fn Key::to_int(self : Key) -> Int = "%identity"

///|
/// Returns whether the selected keyboard key is currently held.
pub fn key(key : Key) -> Bool {
  raw_key(key.to_int()) != 0
}

///|
/// Returns whether any keyboard key is currently held.
pub fn any_key() -> Bool {
  raw_key(-1) != 0
}

///|
fn raw_key(keycode : Int) -> Int = "env" "key"

///|
/// Returns whether a key was newly pressed or repeated.
pub fn keyp(key : Key, hold? : Int = -1, period? : Int = -1) -> Bool {
  raw_keyp(key.to_int(), hold, period) != 0
}

///|
/// Returns whether any keyboard key was newly pressed.
pub fn any_keyp() -> Bool {
  raw_keyp(-1, -1, -1) != 0
}

///|
fn raw_keyp(keycode : Int, hold : Int, period : Int) -> Int = "env" "keyp"

///|
pub fn line(
  x0 : Float,
  y0 : Float,
  x1 : Float,
  y1 : Float,
  color : Int,
) -> Unit = "env" "line"

///|
/// The current tile state passed to a map remap callback, and the replacement
/// state returned by it.
#valtype
pub(all) struct MapRemapResult {
  tile_id : Int
  flip : Int
  rotate : Int
} derive(Debug, Eq)

///|
/// Draws a map region. When present, `remap` receives the current tile state
/// and its map coordinates, and returns the state to draw. The callback must be
/// capture-free because it is stored as a WebAssembly function reference.
pub fn map(
  x? : Int = -1,
  y? : Int = -1,
  w? : Int = -1,
  h? : Int = -1,
  sx? : Int = 0,
  sy? : Int = 0,
  transparent_colors? : Bytes = b"",
  scale? : Int = -1,
  remap? : FuncRef[(MapRemapResult, Int, Int) -> MapRemapResult],
) -> Unit {
  let map_data = match remap {
    None => None
    Some(remap) =>
      Some({
        trampoline: map_remap_trampoline_ref,
        remap,
        result_buffer: FixedArray::make(12, b'\x00'),
      })
  }
  host_map(
    x,
    y,
    w,
    h,
    sx,
    sy,
    transparent_colors,
    transparent_colors.length(),
    scale,
    map_data,
  )
}

///|
/// The field order is the TIC-80 `MapData` ABI: trampoline table index, user
/// data, and result address. The remap function's table index doubles as the
/// user data consumed by `map_remap_trampoline_ref`.
priv struct MapData {
  trampoline : FuncRef[
    (
      FuncRef[(MapRemapResult, Int, Int) -> MapRemapResult],
      Int,
      Int,
      FixedArray[Byte],
    ) -> Unit,
  ]
  remap : FuncRef[(MapRemapResult, Int, Int) -> MapRemapResult]
  result_buffer : FixedArray[Byte]
}

///|
let map_remap_trampoline_ref : FuncRef[
  (
    FuncRef[(MapRemapResult, Int, Int) -> MapRemapResult],
    Int,
    Int,
    FixedArray[Byte],
  ) -> Unit,
] = fn(remap, x, y, result_buffer) {
  let current : MapRemapResult = {
    tile_id: result_buffer[0].to_int(),
    flip: decode_i32_le(result_buffer, 4),
    rotate: decode_i32_le(result_buffer, 8),
  }
  let replacement = remap(current, x, y)
  result_buffer[0] = replacement.tile_id.to_byte()
  encode_i32_le(result_buffer, 4, replacement.flip)
  encode_i32_le(result_buffer, 8, replacement.rotate)
}

///|
#unsafe_skip_stub_check
#borrow(transparent_colors, map_data)
fn host_map(
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
fn decode_i32_le(buffer : FixedArray[Byte], offset : Int) -> Int {
  buffer[offset].to_int() |
  (buffer[offset + 1].to_int() << 8) |
  (buffer[offset + 2].to_int() << 16) |
  (buffer[offset + 3].to_int() << 24)
}

///|
fn encode_i32_le(buffer : FixedArray[Byte], offset : Int, value : Int) -> Unit {
  buffer[offset] = value.to_byte()
  buffer[offset + 1] = (value >> 8).to_byte()
  buffer[offset + 2] = (value >> 16).to_byte()
  buffer[offset + 3] = (value >> 24).to_byte()
}

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
/// Draws ASCII text and returns its width. Panics if `text` contains a
/// non-ASCII code unit.
pub fn print(
  text : StringView,
  x? : Int = 0,
  y? : Int = 0,
  color? : Int = 15,
  fixed? : Bool = false,
  scale? : Int = 1,
  small_font? : Bool = false,
) -> Int {
  host_print(encode_c_text(text), x, y, color, fixed, scale, small_font)
}

///|
#unsafe_skip_stub_check
#borrow(text)
fn host_print(
  text : Bytes,
  x : Int,
  y : Int,
  color : Int,
  fixed : Bool,
  scale : Int,
  small_font : Bool,
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
/// Writes ASCII text to the console. Panics if `text` contains a non-ASCII
/// code unit.
pub fn trace(text : StringView, color? : Int = -1) -> Unit {
  host_trace(encode_c_text(text), color)
}

///|
#unsafe_skip_stub_check
#borrow(text)
fn host_trace(text : Bytes, color : Int) -> Unit = "env" "trace"

///|
fn encode_c_text(text : StringView) -> Bytes {
  @ascii.encode(text) + b"\x00"
}

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
