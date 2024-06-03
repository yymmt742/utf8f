!| String decoration with ascii control characters, collection of input/output controls.
submodule(mod_utf8f) mod_utf8f_nbyte
  implicit none
  include "mask.h"
contains
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
end submodule mod_utf8f_nbyte

