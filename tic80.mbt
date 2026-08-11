// High-level MoonBit wrappers for the TIC-80 WebAssembly API.

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
  @raw.raw_btn(button.to_int()) != 0
}

///|
/// Returns whether any button on any gamepad is currently held.
pub fn any_btn() -> Bool {
  @raw.raw_btn(-1) != 0
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
  { bits: @raw.raw_btn(-1).reinterpret_as_uint() }
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
/// Returns whether a button was newly pressed.
pub fn btnp(button : Button, hold? : Int = -1, period? : Int = -1) -> Bool {
  @raw.raw_btnp(button.to_int(), hold, period) != 0
}

///|
/// Returns whether any button was newly pressed.
pub fn any_btnp() -> Bool {
  @raw.raw_btnp(-1, -1, -1) != 0
}

///|
/// Sets the screen clipping rectangle.
pub fn clip(x : Int, y : Int, w : Int, h : Int) -> Unit {
  @raw.raw_clip(x, y, w, h)
}

///|
/// Restores the clipping rectangle to the full screen.
pub fn clip_reset() -> Unit {
  @raw.raw_clip(-1, -1, -1, -1)
}

///|
/// Clears the screen with a color.
pub fn cls(color? : Int = 0) -> Unit {
  @raw.raw_cls(color)
}

///|
/// Draws a filled circle centered at `(x, y)`.
pub fn circ(x : Int, y : Int, radius : Int, color : Int) -> Unit {
  @raw.raw_circ(x, y, radius, color)
}

///|
/// Draws a one-pixel circle outline centered at `(x, y)`.
pub fn circb(x : Int, y : Int, radius : Int, color : Int) -> Unit {
  @raw.raw_circb(x, y, radius, color)
}

///|
/// Draws a filled ellipse centered at `(x, y)` with the given semi-axes.
pub fn elli(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit {
  @raw.raw_elli(x, y, a, b, color)
}

///|
/// Draws a one-pixel ellipse outline centered at `(x, y)` with the given
/// semi-axes.
pub fn ellib(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit {
  @raw.raw_ellib(x, y, a, b, color)
}

///|
/// Stops the current cartridge and returns to the TIC-80 console.
pub fn exit() -> Unit {
  @raw.raw_exit()
}

///|
/// Returns whether one of a sprite's eight user-defined flags is set.
///
/// `sprite_id` ranges from 0 through 511 and `flag` ranges from 0 through 7.
/// Flag meanings are defined by the cartridge. Panics when either argument is
/// outside its valid range.
pub fn fget(sprite_id : Int, flag : Int) -> Bool {
  check_sprite_flag_args(sprite_id, flag)
  @raw.raw_fget(sprite_id, flag) != 0
}

///|
/// Sets or clears one of a sprite's eight user-defined flags.
///
/// `sprite_id` ranges from 0 through 511 and `flag` ranges from 0 through 7.
/// The change affects runtime RAM; use `sync` with the `Flags` section and
/// `to_cart=true` to copy runtime flags back to a cartridge resource bank.
/// Panics when either argument is outside its valid range.
pub fn fset(sprite_id : Int, flag : Int, value : Bool) -> Unit {
  check_sprite_flag_args(sprite_id, flag)
  @raw.raw_fset(sprite_id, flag, value)
}

///|
fn check_sprite_flag_args(sprite_id : Int, flag : Int) -> Unit {
  if sprite_id < 0 || sprite_id >= 512 {
    abort("sprite id must be between 0 and 511")
  }
  if flag < 0 || flag >= 8 {
    abort("sprite flag must be between 0 and 7")
  }
}

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
  @raw.raw_font(
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
  @raw.raw_key(key.to_int()) != 0
}

///|
/// Returns whether any keyboard key is currently held.
pub fn any_key() -> Bool {
  @raw.raw_key(-1) != 0
}

///|
/// Returns whether a key was newly pressed or repeated.
pub fn keyp(key : Key, hold? : Int = -1, period? : Int = -1) -> Bool {
  @raw.raw_keyp(key.to_int(), hold, period) != 0
}

///|
/// Returns whether any keyboard key was newly pressed.
pub fn any_keyp() -> Bool {
  @raw.raw_keyp(-1, -1, -1) != 0
}

///|
/// Draws a straight line from `(x0, y0)` to `(x1, y1)`.
pub fn line(
  x0 : Float,
  y0 : Float,
  x1 : Float,
  y1 : Float,
  color : Int,
) -> Unit {
  @raw.raw_line(x0, y0, x1, y1, color)
}

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
  let map_data : @raw.MapData? = match remap {
    None => None
    Some(remap) =>
      Some({
        trampoline: map_remap_trampoline_ref,
        user_data: map_remap_to_int(remap),
        result_buffer: FixedArray::make(12, b'\x00'),
      })
  }
  @raw.raw_map(
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
let map_remap_trampoline_ref : FuncRef[
  (Int, Int, Int, FixedArray[Byte]) -> Unit,
] = fn(remap, x, y, result_buffer) {
  let current : MapRemapResult = {
    tile_id: result_buffer[0].to_int(),
    flip: decode_flip(decode_i32_le(result_buffer, 4)),
    rotate: decode_rotation(decode_i32_le(result_buffer, 8)),
  }
  let replacement = map_remap_from_int(remap)(current, x, y)
  result_buffer[0] = replacement.tile_id.to_byte()
  encode_i32_le(result_buffer, 4, replacement.flip.to_int())
  encode_i32_le(result_buffer, 8, replacement.rotate.to_int())
}

///|
fn map_remap_to_int(
  remap : FuncRef[(MapRemapResult, Int, Int) -> MapRemapResult],
) -> Int = "%identity"

///|
fn map_remap_from_int(
  remap : Int,
) -> FuncRef[(MapRemapResult, Int, Int) -> MapRemapResult] = "%identity"

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
/// Copies `length` bytes within TIC-80's 96 KiB RAM.
///
/// `dest` and `src` are byte addresses. The source and destination ranges may
/// overlap. A negative length or a range outside TIC-80 RAM is ignored. This
/// function does not copy MoonBit heap objects or `Bytes` values.
pub fn memcpy(dest : Int, src : Int, length : Int) -> Unit {
  @raw.raw_memcpy(dest, src, length)
}

///|
/// Fills `length` bytes of TIC-80 RAM with `value`.
///
/// `address` is a byte address. A negative length or a range outside TIC-80 RAM
/// is ignored. This function does not operate on MoonBit heap objects or
/// `Bytes` values.
pub fn memset(address : Int, value : Byte, length : Int) -> Unit {
  @raw.raw_memset(address, value, length)
}

///|
/// Returns the tile ID at map coordinates `(x, y)`.
pub fn mget(x : Int, y : Int) -> Int {
  @raw.raw_mget(x, y)
}

///|
/// Sets the tile ID at map coordinates `(x, y)`.
pub fn mset(x : Int, y : Int, tile_id : Int) -> Unit {
  @raw.raw_mset(x, y, tile_id)
}

///|
/// A snapshot of the mouse cursor, wheel, and button state.
///
/// `x` and `y` are screen coordinates. `scroll_x` and `scroll_y` are signed
/// wheel movements for the current frame.
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
  @raw.raw_mouse(buffer)
  decode_mouse_state(buffer)
}

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
/// Panics if `track` is outside the range 0 through 7.
pub fn music(
  track : Int,
  frame? : Int = -1,
  row? : Int = -1,
  loop_? : Bool = true,
  sustain? : Bool = false,
  tempo? : Int = -1,
  speed? : Int = -1,
) -> Unit {
  check_music_track(track)
  @raw.raw_music(track, frame, row, loop_, sustain, tempo, speed)
}

///|
fn check_music_track(track : Int) -> Unit {
  if track < 0 || track >= 8 {
    abort("music: track must be between 0 and 7")
  }
}

///|
/// Stops the currently playing music and resets its channels.
///
/// This does not stop sound effects started independently with `sfx`.
pub fn music_stop() -> Unit {
  @raw.raw_music(-1, -1, -1, false, false, -1, -1)
}

///|
/// Returns the color of a pixel.
pub fn pix(x : Int, y : Int) -> Byte {
  @raw.raw_pix(x, y, -1)
}

///|
/// Draws a pixel.
pub fn pix_set(x : Int, y : Int, color : Int) -> Unit {
  ignore(@raw.raw_pix(x, y, color))
}

///|
/// Reads one byte from TIC-80 RAM at the byte address `address`.
///
/// Returns zero when `address` is outside TIC-80 RAM. Use `peek4`, `peek2`, or
/// `peek1` when the address is expressed in narrower units.
pub fn peek(address : Int) -> Byte {
  @raw.raw_peek(address, 8)
}

///|
/// Reads one four-bit nibble from TIC-80 RAM.
///
/// `address` is a nibble index rather than a byte address. Addresses `2 * n`
/// and `2 * n + 1` select the low and high nibbles of byte `n`, respectively.
/// Returns zero when the address is outside TIC-80 RAM.
pub fn peek4(address : Int) -> Byte {
  @raw.raw_peek4(address)
}

///|
/// Reads one two-bit value from TIC-80 RAM.
///
/// `address` is a two-bit-field index. Addresses `4 * n` through `4 * n + 3`
/// select the four fields of byte `n` from least to most significant. Returns
/// zero when the address is outside TIC-80 RAM.
pub fn peek2(address : Int) -> Byte {
  @raw.raw_peek2(address)
}

///|
/// Reads one bit from TIC-80 RAM.
///
/// `address` is a bit index. Addresses `8 * n` through `8 * n + 7` select the
/// bits of byte `n` from least to most significant. Returns zero when the
/// address is outside TIC-80 RAM.
pub fn peek1(address : Int) -> Byte {
  @raw.raw_peek1(address)
}

///|
/// Reads a value from a persistent-memory slot.
///
/// `index` ranges from 0 through 255. Panics when it is outside that range.
pub fn pmem(index : Int) -> UInt {
  check_pmem_index(index)
  @raw.raw_pmem(index, -1L)
}

///|
/// Writes a persistent-memory slot and returns its previous value.
///
/// `index` ranges from 0 through 255. Panics when it is outside that range.
pub fn pmem_set(index : Int, value : UInt) -> UInt {
  check_pmem_index(index)
  @raw.raw_pmem(index, value.to_int64())
}

///|
fn check_pmem_index(index : Int) -> Unit {
  if index < 0 || index >= 256 {
    abort("persistent-memory index must be between 0 and 255")
  }
}

///|
/// Writes one byte to TIC-80 RAM at the byte address `address`.
///
/// Writes outside TIC-80 RAM are ignored. Use `poke4`, `poke2`, or `poke1`
/// when the address is expressed in narrower units.
pub fn poke(address : Int, value : Byte) -> Unit {
  @raw.raw_poke(address, value.to_int(), 8)
}

///|
/// Writes one four-bit nibble to TIC-80 RAM.
///
/// `address` uses the nibble indexing described by `peek4`; only the low four
/// bits of `value` are stored. Writes outside TIC-80 RAM are ignored.
pub fn poke4(address : Int, value : Byte) -> Unit {
  @raw.raw_poke4(address, value.to_int())
}

///|
/// Writes one two-bit value to TIC-80 RAM.
///
/// `address` uses the two-bit-field indexing described by `peek2`; only the
/// low two bits of `value` are stored. Writes outside TIC-80 RAM are ignored.
pub fn poke2(address : Int, value : Byte) -> Unit {
  @raw.raw_poke2(address, value.to_int())
}

///|
/// Writes one bit to TIC-80 RAM.
///
/// `address` uses the bit indexing described by `peek1`; only the lowest bit
/// of `value` is stored. Writes outside TIC-80 RAM are ignored.
pub fn poke1(address : Int, value : Byte) -> Unit {
  @raw.raw_poke1(address, value.to_int())
}

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
  @raw.raw_print(encode_c_text(text), x, y, color, fixed, scale, small_font)
}

///|
/// Draws a filled rectangle at `(x, y)` with the given size.
pub fn rect(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit {
  @raw.raw_rect(x, y, w, h, color)
}

///|
/// Draws a one-pixel rectangle outline at `(x, y)` with the given size.
pub fn rectb(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit {
  @raw.raw_rectb(x, y, w, h, color)
}

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
  @raw.raw_sfx(
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
  @raw.raw_sfx(-1, 0, 0, -1, channel.to_int(), 15, 15, 8)
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
  @raw.raw_spr(
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
/// A cartridge resource section that can be transferred by `sync`.
///
/// Each variant corresponds to one bit in TIC-80's resource synchronization
/// mask.
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
  @raw.raw_sync(encode_sync_mask(sections), bank, to_cart)
}

///|
fn encode_sync_mask(sections : ArrayView[SyncSection]) -> Int {
  sections.fold(init=0, (mask, section) => mask | (1 << section.to_int()))
}

///|
/// Returns the elapsed time in milliseconds since the cartridge started.
pub fn time() -> Float {
  @raw.raw_time()
}

///|
/// Returns the current Unix timestamp in seconds.
pub fn tstamp() -> UInt {
  @raw.raw_tstamp()
}

///|
/// Writes ASCII text to the console. Panics if `text` contains a non-ASCII
/// code unit.
pub fn trace(text : StringView, color? : Int = -1) -> Unit {
  @raw.raw_trace(encode_c_text(text), color)
}

///|
fn encode_c_text(text : StringView) -> Bytes {
  @ascii.encode(text) + b"\x00"
}

///|
/// Draws a filled triangle with the given vertices.
pub fn tri(
  x1 : Float,
  y1 : Float,
  x2 : Float,
  y2 : Float,
  x3 : Float,
  y3 : Float,
  color : Int,
) -> Unit {
  @raw.raw_tri(x1, y1, x2, y2, x3, y3, color)
}

///|
/// Draws a one-pixel triangle outline with the given vertices.
pub fn trib(
  x1 : Float,
  y1 : Float,
  x2 : Float,
  y2 : Float,
  x3 : Float,
  y3 : Float,
  color : Int,
) -> Unit {
  @raw.raw_trib(x1, y1, x2, y2, x3, y3, color)
}

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
  @raw.raw_ttri(
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
  decode_video_bank(@raw.raw_vbank(-1))
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
  decode_video_bank(@raw.raw_vbank(bank.to_int()))
}

///|
fn decode_video_bank(value : Byte) -> VideoBank {
  if value == b'\x00' {
    Bank0
  } else {
    Bank1
  }
}
