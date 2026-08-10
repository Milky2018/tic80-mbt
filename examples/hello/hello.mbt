///|
#borrow(bytes)
extern "wasm" fn fixed_array_addr(bytes : FixedArray[Byte]) -> Int =
  #|(func (param i32) (result i32) (local.get 0))

///|
#export_name("BOOT")
pub fn boot() -> Unit {
  let scratch = FixedArray::make(10, b'\x00')
  let scratch_addr = fixed_array_addr(scratch)
  ignore(@tic80.btn())
  ignore(@tic80.btnp())
  @tic80.clip()
  @tic80.cls()
  @tic80.circ(0, 0, 0, 0)
  @tic80.circb(0, 0, 0, 0)
  @tic80.elli(0, 0, 0, 0, 0)
  @tic80.ellib(0, 0, 0, 0, 0)
  let sprite_flag = @tic80.fget(0, 0)
  @tic80.fset(0, 0, sprite_flag)
  ignore(@tic80.font(scratch_addr, 0, 0))
  ignore(@tic80.key())
  ignore(@tic80.keyp())
  @tic80.line(0.0, 0.0, 0.0, 0.0, 0)
  @tic80.map(w=0, h=0)
  @tic80.memcpy(0, 0, 0)
  @tic80.memset(0, 0, 0)
  let tile = @tic80.mget(0, 0)
  @tic80.mset(0, 0, tile)
  ignore(@tic80.mouse())
  @tic80.music()
  ignore(@tic80.pix(0, 0))
  let byte = @tic80.peek(0)
  let nibble = @tic80.peek4(0)
  let pair = @tic80.peek2(0)
  let bit = @tic80.peek1(0)
  ignore(@tic80.pmem(0))
  @tic80.poke(0, byte.to_int())
  @tic80.poke4(0, nibble.to_int())
  @tic80.poke2(0, pair.to_int())
  @tic80.poke1(0, bit.to_int())
  ignore(@tic80.print(scratch_addr, 0, 0))
  @tic80.rect(0, 0, 0, 0, 0)
  @tic80.rectb(0, 0, 0, 0, 0)
  @tic80.sfx(-1)
  @tic80.spr(0, 0, 0, w=0, h=0)
  @tic80.sync(mask=0, bank=0, to_cart=false)
  ignore(@tic80.time())
  ignore(@tic80.tstamp())
  @tic80.trace(scratch_addr)
  @tic80.tri(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
  @tic80.trib(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
  @tic80.ttri(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
  ignore(@tic80.vbank(0))
  // Keep `exit` last so every other host import is exercised first.
  @tic80.exit()
}

///|
#export_name("TIC")
pub fn tic() -> Unit {

}
