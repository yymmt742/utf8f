!| String decoration with ascii control characters, collection of input/output controls.
module mod_utf8f
  use ISO_FORTRAN_ENV, only: INT8
  implicit none
  private
  public :: utf8f_len
  public :: utf8f_nbyte
  public :: utf8f_codepoint
  public :: utf8f_category
  public :: utf8f_easta_property
  public :: utf8f_width
  public :: is_ascii
!
  interface
    pure elemental module function utf8f_len(s) result(res)
      character(*), intent(in) :: s
      integer                  :: res
    end function utf8f_len
!
    pure elemental module function utf8f_nbyte(s) result(res)
      character(*), intent(in) :: s
      integer                  :: res
    end function utf8f_nbyte
!
    pure elemental module function utf8f_codepoint(s) result(res)
      character(*), intent(in) :: s
      integer                  :: res
    end function utf8f_codepoint
!
    pure elemental module function utf8f_easta_property(s) result(res)
      character(*), intent(in) :: s
      character(2)             :: res
    end function utf8f_easta_property
!
    pure elemental module function utf8f_category(s) result(res)
      character(*), intent(in) :: s
      character(2)             :: res
    end function utf8f_category
!
    pure elemental module function utf8f_width(s, is_CJK) result(res)
      character(*), intent(in)      :: s
      logical, intent(in), optional :: is_CJK
      integer                       :: res
    end function utf8f_width
!
  end interface
!
contains
!| Returns true if s is ascii character.
  pure function is_ascii(s) result(res)
    character, intent(in)   :: s
    character(*), parameter :: ASCIIAUC = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    character(*), parameter :: ASCIIALC = 'abcdefghijklmnopqrstuvwxyz'
    character(*), parameter :: ASCIINUM = '1234567890'
    character(*), parameter :: ASCIIMRK = ' :;<=>?@[\]^_`{|}~!"#$%&(),.*+/'//"'"
    character(*), parameter :: ASCII = ASCIIAUC//ASCIIALC//ASCIINUM//ASCIIMRK
    logical                 :: res
    res = INDEX(ASCII, s(1:1)) > 0
  end function is_ascii
end module mod_utf8f

