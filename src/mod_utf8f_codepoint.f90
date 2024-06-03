!| String decoration with ascii control characters, collection of input/output controls.
submodule(mod_utf8f) mod_utf8f_codepoint
  use ISO_FORTRAN_ENV, only: INT8
  implicit none
  include "mask.h"
contains
!| Returns number of byte of utf8 string. <br>
  pure elemental function utf8f_codepoint(s) result(res)
    character(*), intent(in) :: s
    integer(INT8)            :: b
    integer                  :: res
    include "codepoint.h"
  end function utf8f_codepoint
end submodule mod_utf8f_codepoint

