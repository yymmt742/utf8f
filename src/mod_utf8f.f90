!| String decoration with ascii control characters, collection of input/output controls.
module mod_utf8f
  use ISO_FORTRAN_ENV, only: INT8
  implicit none
  private
  public :: utf8f_len
  public :: utf8f_nbyte
  public :: utf8f_codepoint
  public :: is_ascii
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
!&>
contains
!| Returns length of utf8 string. <br>
  pure function utf8f_len(s) result(res)
    character(*), intent(in) :: s
    integer                  :: res, i, n
    res = 0
    n = LEN(s)
    do i = 4, n, 4
      if (IAND(ICHAR(s(i - 3:i - 3), INT8), B11000000) /= B10000000) res = res + 1
      if (IAND(ICHAR(s(i - 2:i - 2), INT8), B11000000) /= B10000000) res = res + 1
      if (IAND(ICHAR(s(i - 1:i - 1), INT8), B11000000) /= B10000000) res = res + 1
      if (IAND(ICHAR(s(i - 0:i - 0), INT8), B11000000) /= B10000000) res = res + 1
    end do
    if (MODULO(n, 4) == 1) then
      if (IAND(ICHAR(s(n - 0:n - 0), INT8), B11000000) /= B10000000) res = res + 1
    else if (MODULO(n, 4) == 2) then
      if (IAND(ICHAR(s(n - 1:n - 1), INT8), B11000000) /= B10000000) res = res + 1
      if (IAND(ICHAR(s(n - 0:n - 0), INT8), B11000000) /= B10000000) res = res + 1
    else if (MODULO(n, 4) == 3) then
      if (IAND(ICHAR(s(n - 2:n - 2), INT8), B11000000) /= B10000000) res = res + 1
      if (IAND(ICHAR(s(n - 1:n - 1), INT8), B11000000) /= B10000000) res = res + 1
      if (IAND(ICHAR(s(n - 0:n - 0), INT8), B11000000) /= B10000000) res = res + 1
    end if
  end function utf8f_len
!
!| Returns number of byte of utf8 string. <br>
  pure elemental function utf8f_nbyte(s) result(res)
    character, intent(in)    :: s
    integer(INT8)            :: b
    integer                  :: res
!<&
    b = IACHAR(s, INT8)
    if (IAND(b, B10000000) == B00000000) then     ; res = 1
    elseif (IAND(b, B11100000) == B11000000) then ; res = 2
    elseif (IAND(b, B11110000) == B11100000) then ; res = 3
    elseif (IAND(b, B11111000) == B11110000) then ; res = 4
    elseif (IAND(b, B11111100) == B11111000) then ; res = 5
    elseif (IAND(b, B11111110) == B11111100) then ; res = 6
    else                                          ; res = 0
    end if
!&>
  end function utf8f_nbyte
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
!| Returns true if s is ascii character.
  pure function is_ascii(s) result(res)
    character, intent(in)    :: s
    character(*), parameter  :: ASCIIAUC = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    character(*), parameter  :: ASCIIALC = 'abcdefghijklmnopqrstuvwxyz'
    character(*), parameter  :: ASCIINUM = '1234567890'
    character(*), parameter  :: ASCIIMRK = ' :;<=>?@[\]^_`{|}~!"#$%&(),.*+/'//"'"
    character(*), parameter  :: ASCII = ASCIIAUC//ASCIIALC//ASCIINUM//ASCIIMRK
    logical                  :: res
    res = INDEX(ASCII, s(1:1)) > 0
  end function is_ascii
end module mod_utf8f

