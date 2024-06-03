!| returns unicode character easta_property
submodule(mod_utf8f) mod_utf8f_easta_property
  implicit none
contains
  pure elemental module function utf8f_easta_property(s) result(res)
    character(*), intent(in) :: s
    character(2)             :: res
    integer                  :: c
    res = ""
    c = codepoint(s)
    if (c < 1) return
    call get_utf8f_easta_property(c, res)
  end function utf8f_easta_property
!
  pure subroutine get_utf8f_easta_property(codepoint, res)
    integer, intent(in)         :: codepoint
    character(2), intent(inout) :: res
    include "easta_property_table.h"
    integer                     :: ind
    call binary_search(codepoint, 1, N_TABLE, N_TABLE, &
   &                   INDEX_TABLE, ind)
    res = table(ind)
  end subroutine get_utf8f_easta_property
!
!| Returns number of byte of utf8 string. <br>
  pure elemental function codepoint(s) result(res)
    character(*), intent(in) :: s
    integer(INT8)            :: b
    integer                  :: res
    include "mask.h"
    include "codepoint.h"
  end function codepoint
!
  include "binary_search.h"
!
end submodule mod_utf8f_easta_property

