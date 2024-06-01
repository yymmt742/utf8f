!| String decoration with ascii control characters, collection of input/output controls.
module mod_utf8f
  use ISO_FORTRAN_ENV, only: &
 &   iolib_STDIN => INPUT_UNIT, &
 &   iolib_STDOUT => OUTPUT_UNIT, &
 &   iolib_STDERR => ERROR_UNIT
  implicit none
  private
  public :: utf8f_len
  public :: utf8f_nbyte
  public :: is_ascii
!
contains
!| Returns length of utf8 string. <br>
  pure function utf8f_len(s) result(res)
    use ISO_FORTRAN_ENV, only: INT8
    character(*), intent(in) :: s
    integer(INT8), parameter :: ZC0 = -64_INT8
    integer(INT8), parameter :: Z80 = -127_INT8 - 1_INT8
    integer                  :: res, i, n
    res = 0
    n = LEN(s)
    do i = 1, n
      if (IAND(ICHAR(s(i:i), INT8), ZC0) /= Z80) res = res + 1
    end do
  end function utf8f_len
!
!| Returns number of byte of utf8 string. <br>
  pure elemental function utf8f_nbyte(s) result(res)
    use ISO_FORTRAN_ENV, only: INT8
    character, intent(in)    :: s
    integer(INT8)            :: b
    integer(INT8), parameter :: Z00 = 0_INT8
    integer(INT8), parameter :: ZFE = -2_INT8
    integer(INT8), parameter :: ZFC = -4_INT8
    integer(INT8), parameter :: ZF8 = -8_INT8
    integer(INT8), parameter :: ZF0 = -16_INT8
    integer(INT8), parameter :: ZE0 = -32_INT8
    integer(INT8), parameter :: ZC0 = -64_INT8
    integer(INT8), parameter :: Z80 = -127_INT8 - 1_INT8
    integer                  :: res
    res = 0
    b = IACHAR(s(1:1), INT8)
    if (IAND(b, Z80) == Z00) then
      res = MERGE(1, 0, is_ascii(s))
    elseif (IAND(b, ZE0) == ZC0) then
      res = 2
    elseif (IAND(b, ZF0) == ZE0) then
      res = 3
    elseif (IAND(b, ZF8) == ZF0) then
      res = 4
    elseif (IAND(b, ZFC) == ZF8) then
      res = 5
    elseif (IAND(b, ZFE) == ZFC) then
      res = 6
    else
      res = 0
    end if
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

