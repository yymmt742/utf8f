  pure elemental function utf8f_easta_property(s) result(res)
    character(*), intent(in) :: s
    character(2)             :: res
    integer                  :: c
    res = ""
    c = utf8f_codepoint(s)
    if (c < 1) return
    call get_utf8f_easta_property(c, res)
  end function utf8f_easta_property
!
  pure subroutine get_utf8f_easta_property(codepoint, res)
    integer, intent(in)         :: codepoint
    character(2), intent(inout) :: res
    include "easta_property_table.h"
    integer                     :: ind
    if (codepoint > INDEX_TABLE(N_TABLE)) return
    call binary_search(codepoint, 1, N_TABLE, N_TABLE, &
   &                   INDEX_TABLE, ind)
    res = table(ind)
  end subroutine get_utf8f_easta_property

