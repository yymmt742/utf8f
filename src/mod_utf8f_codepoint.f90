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

