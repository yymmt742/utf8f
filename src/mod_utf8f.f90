!| String decoration with ascii control characters, collection of input/output controls.
module mod_utf8f
  use ISO_FORTRAN_ENV, only: INT8
  implicit none
  private
  public :: utf8f_len
  public :: utf8f_nbyte
  public :: utf8f_width
  public :: utf8f_codepoint
  public :: is_ascii
!
  include "mask.h"
!
  interface
    pure elemental module function utf8f_codepoint(s) result(res)
    character(*), intent(in) :: s
    integer                  :: res
    end function utf8f_codepoint
!
    pure module function utf8f_width(s, is_CJK) result(res)
    character(*), intent(in) :: s
    logical, intent(in)      :: is_CJK
    integer                  :: res
    end function utf8f_width
!
  end interface
!
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

