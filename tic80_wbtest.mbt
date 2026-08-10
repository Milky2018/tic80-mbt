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
