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

///|
test "key codes match the TIC-80 ABI" {
  let keys : Array[(Key, Int)] = [
    (A, 1),
    (B, 2),
    (C, 3),
    (D, 4),
    (E, 5),
    (F, 6),
    (G, 7),
    (H, 8),
    (I, 9),
    (J, 10),
    (K, 11),
    (L, 12),
    (M, 13),
    (N, 14),
    (O, 15),
    (P, 16),
    (Q, 17),
    (R, 18),
    (S, 19),
    (T, 20),
    (U, 21),
    (V, 22),
    (W, 23),
    (X, 24),
    (Y, 25),
    (Z, 26),
    (Digit0, 27),
    (Digit1, 28),
    (Digit2, 29),
    (Digit3, 30),
    (Digit4, 31),
    (Digit5, 32),
    (Digit6, 33),
    (Digit7, 34),
    (Digit8, 35),
    (Digit9, 36),
    (Minus, 37),
    (Equals, 38),
    (LeftBracket, 39),
    (RightBracket, 40),
    (Backslash, 41),
    (Semicolon, 42),
    (Apostrophe, 43),
    (Grave, 44),
    (Comma, 45),
    (Period, 46),
    (Slash, 47),
    (Space, 48),
    (Tab, 49),
    (Return, 50),
    (Backspace, 51),
    (Delete, 52),
    (Insert, 53),
    (PageUp, 54),
    (PageDown, 55),
    (Home, 56),
    (End, 57),
    (Up, 58),
    (Down, 59),
    (Left, 60),
    (Right, 61),
    (CapsLock, 62),
    (Ctrl, 63),
    (Shift, 64),
    (Alt, 65),
    (Escape, 66),
    (F1, 67),
    (F2, 68),
    (F3, 69),
    (F4, 70),
    (F5, 71),
    (F6, 72),
    (F7, 73),
    (F8, 74),
    (F9, 75),
    (F10, 76),
    (F11, 77),
    (F12, 78),
    (Numpad0, 79),
    (Numpad1, 80),
    (Numpad2, 81),
    (Numpad3, 82),
    (Numpad4, 83),
    (Numpad5, 84),
    (Numpad6, 85),
    (Numpad7, 86),
    (Numpad8, 87),
    (Numpad9, 88),
    (NumpadPlus, 89),
    (NumpadMinus, 90),
    (NumpadMultiply, 91),
    (NumpadDivide, 92),
    (NumpadEnter, 93),
    (NumpadPeriod, 94),
  ]
  for pair in keys {
    assert_eq(pair.0.to_int(), pair.1)
  }
}
