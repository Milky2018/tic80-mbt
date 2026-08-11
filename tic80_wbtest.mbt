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
  assert_false(empty.held(P1Up))
  assert_false(empty.held(P4Y))
  let buttons : ButtonState = { bits: (1U << 0) | (1U << 31) }
  assert_true(buttons.any())
  assert_true(buttons.held(P1Up))
  assert_false(buttons.held(P1Down))
  assert_true(buttons.held(P4Y))
}

///|
test "button IDs match the TIC-80 ABI" {
  let buttons : Array[(Button, Int)] = [
    (P1Up, 0),
    (P1Down, 1),
    (P1Left, 2),
    (P1Right, 3),
    (P1A, 4),
    (P1B, 5),
    (P1X, 6),
    (P1Y, 7),
    (P2Up, 8),
    (P2Down, 9),
    (P2Left, 10),
    (P2Right, 11),
    (P2A, 12),
    (P2B, 13),
    (P2X, 14),
    (P2Y, 15),
    (P3Up, 16),
    (P3Down, 17),
    (P3Left, 18),
    (P3Right, 19),
    (P3A, 20),
    (P3B, 21),
    (P3X, 22),
    (P3Y, 23),
    (P4Up, 24),
    (P4Down, 25),
    (P4Left, 26),
    (P4Right, 27),
    (P4A, 28),
    (P4B, 29),
    (P4X, 30),
    (P4Y, 31),
  ]
  for pair in buttons {
    assert_eq(pair.0.to_int(), pair.1)
  }
}
