!| String decoration with ascii control characters, collection of input/output controls.
submodule(mod_utf8f) mod_utf8f_codepoint
  use ISO_FORTRAN_ENV, only: INT8
  implicit none
!<&
  integer(INT8), parameter :: B11111110 =   -2_INT8
  integer(INT8), parameter :: B11111100 =   -4_INT8
  integer(INT8), parameter :: B11111000 =   -8_INT8
  integer(INT8), parameter :: B11110000 =  -16_INT8
  integer(INT8), parameter :: B11100000 =  -32_INT8
  integer(INT8), parameter :: B11000000 =  -64_INT8
  integer(INT8), parameter :: B10000000 = -127_INT8 - 1_INT8
  integer(INT8), parameter :: B00000000 =    0_INT8
  integer(INT8), parameter :: B00111111 =   63_INT8
  integer(INT8), parameter :: B00011111 =   31_INT8
  integer(INT8), parameter :: B00001111 =   15_INT8
  integer(INT8), parameter :: B00000111 =    7_INT8
  integer(INT8), parameter :: B00000011 =    3_INT8
  integer(INT8), parameter :: B00000001 =    1_INT8
!
contains
!
!| Returns number of byte of utf8 string. <br>
  pure elemental function utf8f_codepoint(s) result(res)
    character(*), intent(in) :: s
    integer(INT8)            :: b
    integer                  :: res
!<&
    b = IACHAR(s(1:1), INT8)
    if (    IAND(b, B10000000) == B00000000) then
      res = b
    elseif (IAND(b, B11100000) == B11000000) then
      res = IAND(b, B00011111)
      res = IAND(IACHAR(s(2:2), INT8), B00111111) + ISHFT(res, 6)
    elseif (IAND(b, B11110000) == B11100000) then
      res = IAND(b, B00001111)
      res = IAND(IACHAR(s(2:2), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(3:3), INT8), B00111111) + ISHFT(res, 6)
    elseif (IAND(b, B11111000) == B11110000) then
      res = IAND(b, B00000111)
      res = IAND(IACHAR(s(2:2), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(3:3), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(4:4), INT8), B00111111) + ISHFT(res, 6)
    elseif (IAND(b, B11111100) == B11111000) then
      res = IAND(b, B00000011)
      res = IAND(IACHAR(s(2:2), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(3:3), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(4:4), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(5:5), INT8), B00111111) + ISHFT(res, 6)
    elseif (IAND(b, B11111110) == B11111100) then
      res = IAND(b, B00000001)
      res = IAND(IACHAR(s(2:2), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(3:3), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(4:4), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(5:5), INT8), B00111111) + ISHFT(res, 6)
      res = IAND(IACHAR(s(6:6), INT8), B00111111) + ISHFT(res, 6)
    else
      res = 0
    end if
!&>
  end function utf8f_codepoint
!
end submodule mod_utf8f_codepoint

