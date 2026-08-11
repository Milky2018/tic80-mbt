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
/// Sets the screen clipping rectangle.
pub fn clip(x : Int, y : Int, w : Int, h : Int) -> Unit {
  raw_clip(x, y, w, h)
}

///|
/// Restores the clipping rectangle to the full screen.
pub fn clip_reset() -> Unit {
  raw_clip(-1, -1, -1, -1)
}

///|
fn raw_clip(x : Int, y : Int, w : Int, h : Int) -> Unit = "env" "clip"

///|
/// Clears the screen with a color.
pub fn cls(color? : Int = 0) -> Unit = "env" "cls"

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
/// A sprite or map tile flip applied by TIC-80.
pub(all) enum Flip {
  NoFlip = 0
  Horizontal = 1
  Vertical = 2
  Both = 3
} derive(Debug, Eq)

///|
fn Flip::to_int(self : Flip) -> Int = "%identity"

///|
/// A clockwise sprite or map tile rotation applied by TIC-80.
pub(all) enum Rotation {
  NoRotation = 0
  Clockwise90 = 1
  Clockwise180 = 2
  Clockwise270 = 3
} derive(Debug, Eq)

///|
fn Rotation::to_int(self : Rotation) -> Int = "%identity"

///|
/// The current tile state passed to a map remap callback, and the replacement
/// state returned by it.
#valtype
pub(all) struct MapRemapResult {
  tile_id : Int
  flip : Flip
  rotate : Rotation
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
    flip: decode_flip(decode_i32_le(result_buffer, 4)),
    rotate: decode_rotation(decode_i32_le(result_buffer, 8)),
  }
  let replacement = remap(current, x, y)
  result_buffer[0] = replacement.tile_id.to_byte()
  encode_i32_le(result_buffer, 4, replacement.flip.to_int())
  encode_i32_le(result_buffer, 8, replacement.rotate.to_int())
}

///|
fn decode_flip(value : Int) -> Flip {
  match value & 3 {
    0 => NoFlip
    1 => Horizontal
    2 => Vertical
    _ => Both
  }
}

///|
fn decode_rotation(value : Int) -> Rotation {
  match value & 3 {
    0 => NoRotation
    1 => Clockwise90
    2 => Clockwise180
    _ => Clockwise270
  }
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
/// Starts playing one of the eight tracks created in TIC-80's Music Editor.
///
/// `track` ranges from 0 through 7. By default playback starts at the beginning
/// of the track, loops after its final populated frame, does not sustain notes
/// across frame boundaries, and uses the tempo and speed stored in the track.
/// Use `frame` and `row` to start at a specific position, or `tempo` and `speed`
/// to override the track settings. Call `music_stop` to stop playback.
pub fn music(
  track : Int,
  frame? : Int = -1,
  row? : Int = -1,
  loop_? : Bool = true,
  sustain? : Bool = false,
  tempo? : Int = -1,
  speed? : Int = -1,
) -> Unit {
  raw_music(track, frame, row, loop_, sustain, tempo, speed)
}

///|
/// Stops the currently playing music and resets its channels.
///
/// This does not stop sound effects started independently with `sfx`.
pub fn music_stop() -> Unit {
  raw_music(-1, -1, -1, false, false, -1, -1)
}

///|
fn raw_music(
  track : Int,
  frame : Int,
  row : Int,
  loop_ : Bool,
  sustain : Bool,
  tempo : Int,
  speed : Int,
) -> Unit = "env" "music"

///|
/// Returns the color of a pixel.
pub fn pix(x : Int, y : Int) -> Byte {
  raw_pix(x, y, -1)
}

///|
/// Draws a pixel.
pub fn pix_set(x : Int, y : Int, color : Int) -> Unit {
  ignore(raw_pix(x, y, color))
}

///|
fn raw_pix(x : Int, y : Int, color : Int) -> Byte = "env" "pix"

///|
pub fn peek(address : Int, bits? : Int = 8) -> Byte = "env" "peek"

///|
pub fn peek4(address : Int) -> Byte = "env" "peek4"

///|
pub fn peek2(address : Int) -> Byte = "env" "peek2"

///|
pub fn peek1(address : Int) -> Byte = "env" "peek1"

///|
/// Reads a value from a persistent-memory slot.
pub fn pmem(index : Int) -> UInt {
  raw_pmem(index, -1L)
}

///|
/// Writes a persistent-memory slot and returns its previous value.
pub fn pmem_set(index : Int, value : UInt) -> UInt {
  raw_pmem(index, value.to_int64())
}

///|
fn raw_pmem(index : Int, value : Int64) -> UInt = "env" "pmem"

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
/// One of TIC-80's four sound-effect channels.
///
/// The explicit tags are the channel IDs expected by the TIC-80 host ABI.
pub(all) enum SfxChannel {
  Channel0 = 0
  Channel1 = 1
  Channel2 = 2
  Channel3 = 3
} derive(Debug, Eq)

///|
fn SfxChannel::to_int(self : SfxChannel) -> Int = "%identity"

///|
/// Plays one of the 64 effects created in TIC-80's SFX Editor.
///
/// `note` is a combined note number from 0 through 95, with twelve notes per
/// octave. When omitted, the note stored in the selected effect is used.
/// `duration` is measured in 60 Hz ticks; -1 plays continuously. The left and
/// right volumes range from 0 through 15. When `speed` is omitted, the speed
/// stored in the selected effect is used; explicit speeds range from -4 through
/// 3. Call `sfx_stop` to stop an effect on a channel.
///
/// Panics if `id` is outside the range 0 through 63.
pub fn sfx(
  id : Int,
  note? : Int,
  duration? : Int = -1,
  channel? : SfxChannel = Channel0,
  volume_left? : Int = 15,
  volume_right? : Int = 15,
  speed? : Int,
) -> Unit {
  if id < 0 || id >= 64 {
    abort("sfx: id must be between 0 and 63")
  }
  let combined_note = match note {
    None => read_sfx_default_note(id)
    Some(note) => note
  }
  let (raw_note, raw_octave) = split_sfx_note(combined_note)
  let raw_speed = match speed {
    None => 8
    Some(speed) => speed
  }
  raw_sfx(
    id,
    raw_note,
    raw_octave,
    duration,
    channel.to_int(),
    volume_left,
    volume_right,
    raw_speed,
  )
}

///|
/// Stops the sound effect playing on `channel`.
///
/// This does not stop music playback or effects on the other channels.
pub fn sfx_stop(channel? : SfxChannel = Channel0) -> Unit {
  raw_sfx(-1, 0, 0, -1, channel.to_int(), 15, 15, 8)
}

///|
fn read_sfx_default_note(id : Int) -> Int {
  // TIC-80 stores 64 66-byte effects at 0x100e4. The final two bytes hold
  // the effect's octave, speed, note, and stereo flags.
  let metadata_address = 0x100e4 + id * 66 + 64
  decode_sfx_default_note(peek(metadata_address), peek(metadata_address + 1))
}

///|
fn decode_sfx_default_note(metadata0 : Byte, metadata1 : Byte) -> Int {
  let octave = metadata0.to_int() & 0x07
  let note = metadata1.to_int() & 0x0f
  note + octave * 12
}

///|
fn split_sfx_note(note : Int) -> (Int, Int) {
  (note % 12, note / 12)
}

///|
fn raw_sfx(
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
/// Transparent colors are passed directly from `transparent_colors`.
pub fn spr(
  id : Int,
  x : Int,
  y : Int,
  transparent_colors? : Bytes = b"",
  scale? : Int = 1,
  flip? : Flip = NoFlip,
  rotate? : Rotation = NoRotation,
  w? : Int = 1,
  h? : Int = 1,
) -> Unit {
  host_spr(
    id,
    x,
    y,
    transparent_colors,
    transparent_colors.length(),
    scale,
    flip.to_int(),
    rotate.to_int(),
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
pub(all) enum SyncSection {
  Tiles
  Sprites
  Map
  Sfx
  Music
  Palette
  Flags
  Screen
} derive(Debug, Eq)

///|
fn SyncSection::to_int(self : SyncSection) -> Int = "%identity"

///|
/// Synchronizes cartridge resources with runtime memory. An empty `sections`
/// list selects every section. By default, data is copied from bank 0 into
/// runtime memory; set `to_cart` to copy runtime data back to the bank. Each
/// section can only be synchronized once per frame.
pub fn sync(
  sections? : ArrayView[SyncSection] = [],
  bank? : Int = 0,
  to_cart? : Bool = false,
) -> Unit {
  raw_sync(encode_sync_mask(sections), bank, to_cart)
}

///|
fn encode_sync_mask(sections : ArrayView[SyncSection]) -> Int {
  sections.fold(init=0, (mask, section) => mask | (1 << section.to_int()))
}

///|
fn raw_sync(mask : Int, bank : Int, to_cart : Bool) -> Unit = "env" "sync"

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
/// The texture sampled by `ttri`.
///
/// `TileSheet` samples image RAM through the active tile or sprite-sheet
/// segment. `TileMap` samples map RAM and resolves its tile IDs through image
/// RAM. `OtherVideoBank` samples the framebuffer of the video bank that is not
/// currently selected by `vbank_set`.
pub(all) enum TextureSource {
  TileSheet = 0
  TileMap = 1
  OtherVideoBank = 2
} derive(Debug, Eq)

///|
fn TextureSource::to_int(self : TextureSource) -> Int = "%identity"

///|
/// Draws a triangle textured from `texture_source`.
///
/// The `u` and `v` coordinates are interpreted in the coordinate space of the
/// selected source. When `OtherVideoBank` is selected, `ttri` samples whichever
/// video bank is not currently selected: it normally samples `Bank1` while
/// drawing to `Bank0`, and samples `Bank0` while drawing to `Bank1`.
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
  texture_source? : TextureSource = TileSheet,
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
    texture_source.to_int(),
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
/// One of TIC-80's two 16 KiB video-memory banks.
///
/// Drawing commands and direct VRAM access operate on the selected bank.
/// `Bank1` is composited over `Bank0`; pixels matching `Bank1`'s clear color
/// are transparent and reveal `Bank0`. Video banks are always available and
/// are unrelated to the cartridge resource banks selected by `sync`.
pub(all) enum VideoBank {
  Bank0 = 0
  Bank1 = 1
} derive(Debug, Eq)

///|
fn VideoBank::to_int(self : VideoBank) -> Int = "%identity"

///|
/// Returns the currently selected video bank without changing it.
///
/// Use `vbank_set` when subsequent drawing or direct VRAM operations should
/// target a different bank.
pub fn vbank() -> VideoBank {
  decode_video_bank(raw_vbank(-1))
}

///|
/// Selects the video bank used by subsequent drawing and direct VRAM
/// operations, and returns the previously selected bank.
///
/// The return value makes temporary switching straightforward: save it, draw
/// into another bank, then pass it back to `vbank_set` to restore the previous
/// target. This only switches VRAM; it does not select a cartridge resource
/// bank for `sync`.
pub fn vbank_set(bank : VideoBank) -> VideoBank {
  decode_video_bank(raw_vbank(bank.to_int()))
}

///|
fn decode_video_bank(value : Byte) -> VideoBank {
  if value == b'\x00' {
    Bank0
  } else {
    Bank1
  }
}

///|
fn raw_vbank(bank : Int) -> Byte = "env" "vbank"
