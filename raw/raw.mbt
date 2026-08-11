// Raw TIC-80 WebAssembly imports.
//
// The signatures mirror `linkTicAPI` from TIC-80 commit
// `4aba09c98f1e5028b82765be1647677b08d35942`.
// Address arguments are byte offsets in the imported linear memory.

///|
pub fn raw_btn(id : Int) -> Int = "env" "btn"

///|
pub fn raw_btnp(id : Int, hold : Int, period : Int) -> Int = "env" "btnp"

///|
pub fn raw_clip(x : Int, y : Int, w : Int, h : Int) -> Unit = "env" "clip"

///|
pub fn raw_cls(color : Int) -> Unit = "env" "cls"

///|
pub fn raw_circ(x : Int, y : Int, radius : Int, color : Int) -> Unit = "env" "circ"

///|
pub fn raw_circb(x : Int, y : Int, radius : Int, color : Int) -> Unit = "env" "circb"

///|
pub fn raw_elli(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit = "env" "elli"

///|
pub fn raw_ellib(x : Int, y : Int, a : Int, b : Int, color : Int) -> Unit = "env" "ellib"

///|
pub fn raw_exit() -> Unit = "env" "exit"

///|
pub fn raw_fget(sprite_id : Int, flag : Int) -> Int = "env" "fget"

///|
pub fn raw_fset(sprite_id : Int, flag : Int, value : Bool) -> Unit = "env" "fset"

///|
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
pub fn raw_key(keycode : Int) -> Int = "env" "key"

///|
pub fn raw_keyp(keycode : Int, hold : Int, period : Int) -> Int = "env" "keyp"

///|
pub fn raw_line(
  x0 : Float,
  y0 : Float,
  x1 : Float,
  y1 : Float,
  color : Int,
) -> Unit = "env" "line"

///|
/// The field order is the TIC-80 `MapData` ABI: trampoline table index, user
/// data, and result address.
pub(all) struct MapData {
  trampoline : FuncRef[(Int, Int, Int, FixedArray[Byte]) -> Unit]
  user_data : Int
  result_buffer : FixedArray[Byte]
}

///|
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
pub fn raw_memcpy(dest : Int, src : Int, length : Int) -> Unit = "env" "memcpy"

///|
pub fn raw_memset(address : Int, value : Byte, length : Int) -> Unit = "env" "memset"

///|
pub fn raw_mget(x : Int, y : Int) -> Int = "env" "mget"

///|
pub fn raw_mset(x : Int, y : Int, tile_id : Int) -> Unit = "env" "mset"

///|
#unsafe_skip_stub_check
#borrow(buffer)
pub fn raw_mouse(buffer : FixedArray[Byte]) -> Unit = "env" "mouse"

///|
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
pub fn raw_pix(x : Int, y : Int, color : Int) -> Byte = "env" "pix"

///|
pub fn raw_peek(address : Int, bits : Int) -> Byte = "env" "peek"

///|
pub fn raw_peek4(address : Int) -> Byte = "env" "peek4"

///|
pub fn raw_peek2(address : Int) -> Byte = "env" "peek2"

///|
pub fn raw_peek1(address : Int) -> Byte = "env" "peek1"

///|
pub fn raw_pmem(index : Int, value : Int64) -> UInt = "env" "pmem"

///|
pub fn raw_poke(address : Int, value : Int, bits : Int) -> Unit = "env" "poke"

///|
pub fn raw_poke4(address : Int, value : Int) -> Unit = "env" "poke4"

///|
pub fn raw_poke2(address : Int, value : Int) -> Unit = "env" "poke2"

///|
pub fn raw_poke1(address : Int, value : Int) -> Unit = "env" "poke1"

///|
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
pub fn raw_rect(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit = "env" "rect"

///|
pub fn raw_rectb(x : Int, y : Int, w : Int, h : Int, color : Int) -> Unit = "env" "rectb"

///|
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
pub fn raw_sync(mask : Int, bank : Int, to_cart : Bool) -> Unit = "env" "sync"

///|
pub fn raw_time() -> Float = "env" "time"

///|
pub fn raw_tstamp() -> UInt = "env" "tstamp"

///|
#unsafe_skip_stub_check
#borrow(text)
pub fn raw_trace(text : Bytes, color : Int) -> Unit = "env" "trace"

///|
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
pub fn raw_vbank(bank : Int) -> Byte = "env" "vbank"
