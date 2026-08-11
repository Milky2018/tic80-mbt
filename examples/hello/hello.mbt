///|
#export_name("BOOT")
pub fn boot() -> Unit {
  ignore(@tic80.btn(P1Up))
  ignore(@tic80.any_btn())
  let buttons = @tic80.button_state()
  ignore(buttons.held(P1Up))
  ignore(buttons.any())
  ignore(@tic80.btnp(P1Up))
  ignore(@tic80.any_btnp())
  @tic80.clip(0, 0, 240, 136)
  @tic80.clip_reset()
  @tic80.cls()
  @tic80.circ(0, 0, 0, 0)
  @tic80.circb(0, 0, 0, 0)
  @tic80.elli(0, 0, 0, 0, 0)
  @tic80.ellib(0, 0, 0, 0, 0)
  let sprite_flag = @tic80.fget(0, 0)
  @tic80.fset(0, 0, sprite_flag)
  ignore(@tic80.font("", 0, 0))
  ignore(@tic80.key(A))
  ignore(@tic80.any_key())
  ignore(@tic80.keyp(A))
  ignore(@tic80.any_keyp())
  @tic80.line(0.0, 0.0, 0.0, 0.0, 0)
  let map_remap : FuncRef[
    (@tic80.MapRemapResult, Int, Int) -> @tic80.MapRemapResult,
  ] = fn(tile, _x, _y) { tile }
  @tic80.map(w=1, h=1, remap=map_remap)
  @tic80.memcpy(0, 0, 0)
  @tic80.memset(0, 0, 0)
  let tile = @tic80.mget(0, 0)
  @tic80.mset(0, 0, tile)
  ignore(@tic80.mouse())
  @tic80.music(0)
  @tic80.music_stop()
  let color = @tic80.pix(0, 0)
  @tic80.pix_set(0, 0, color.to_int())
  let byte = @tic80.peek(0)
  let nibble = @tic80.peek4(0)
  let pair = @tic80.peek2(0)
  let bit = @tic80.peek1(0)
  let persistent = @tic80.pmem(0)
  ignore(@tic80.pmem_set(0, persistent))
  @tic80.poke(0, byte.to_int())
  @tic80.poke4(0, nibble.to_int())
  @tic80.poke2(0, pair.to_int())
  @tic80.poke1(0, bit.to_int())
  ignore(@tic80.print(""))
  @tic80.rect(0, 0, 0, 0, 0)
  @tic80.rectb(0, 0, 0, 0, 0)
  @tic80.sfx(-1)
  @tic80.spr(0, 0, 0, flip=Horizontal, rotate=Clockwise90, w=0, h=0)
  @tic80.sync(sections=[Tiles], bank=0, to_cart=false)
  ignore(@tic80.time())
  ignore(@tic80.tstamp())
  @tic80.trace("")
  @tic80.tri(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
  @tic80.trib(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
  @tic80.ttri(
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    texture_source=TileMap,
  )
  let current_video_bank = @tic80.vbank()
  ignore(@tic80.vbank_set(current_video_bank))
  // Keep `exit` last so every other host import is exercised first.
  @tic80.exit()
}

///|
#export_name("TIC")
pub fn tic() -> Unit {

}
