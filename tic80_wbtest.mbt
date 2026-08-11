// Whitebox tests run within the package scope.
// Use them to validate internal helpers or invariants.
// Keep them focused; public behavior belongs in `_test.mbt`.

///|
test "decode mouse state" {
  let buffer : FixedArray[Byte] = [
    b'\xfe', b'\xff', b'\x2c', b'\x01', b'\x80', b'\x7f', b'\x01', b'\x00', b'\x02',
  ]
  let expected : MouseState = {
    x: -2,
    y: 300,
    scroll_x: -128,
    scroll_y: 127,
    left: true,
    middle: false,
    right: true,
  }
  assert_eq(decode_mouse_state(buffer), expected)
}

///|
test "map remap trampoline" {
  let buffer : FixedArray[Byte] = [
    b'\x07', b'\x00', b'\x00', b'\x00', b'\x02', b'\x00', b'\x00', b'\x00', b'\xfd',
    b'\xff', b'\xff', b'\xff',
  ]
  let remap : FuncRef[(MapRemapResult, Int, Int) -> MapRemapResult] = fn(
    current,
    x,
    y,
  ) {
    {
      tile_id: current.tile_id + x,
      flip: current.flip + y,
      rotate: -current.rotate,
    }
  }
  map_remap_trampoline_ref(remap, 4, 3, buffer)
  assert_eq(buffer[0], b'\x0b')
  assert_eq(decode_i32_le(buffer, 4), 5)
  assert_eq(decode_i32_le(buffer, 8), 3)
}

///|
test "encode C text" {
  assert_eq(encode_c_text("TIC\n80"), b"TIC\n80\x00")
}
