!| String decoration with ascii control characters, collection of input/output controls.
submodule(mod_utf8f) mod_utf8f_len
  use ISO_FORTRAN_ENV, only: INT8
  implicit none
  include "mask.h"
contains
!| Returns length of utf8 string. <br>
  pure elemental function utf8f_len(s) result(res)
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
end submodule mod_utf8f_len

