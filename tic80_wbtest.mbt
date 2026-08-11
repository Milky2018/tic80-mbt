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

///|
test "decode button state" {
  let empty : ButtonState = { bits: 0U }
  assert_false(empty.any())
  assert_false(empty.held(0))
  assert_false(empty.held(31))
  let buttons : ButtonState = { bits: (1U << 0) | (1U << 31) }
  assert_true(buttons.any())
  assert_true(buttons.held(0))
  assert_false(buttons.held(1))
  assert_true(buttons.held(31))
}

///|
test "panic ButtonState::held rejects a negative button id" {
  let buttons : ButtonState = { bits: 0U }
  ignore(buttons.held(-1))
}

///|
test "panic ButtonState::held rejects a button id above the range" {
  let buttons : ButtonState = { bits: 0U }
  ignore(buttons.held(32))
}
