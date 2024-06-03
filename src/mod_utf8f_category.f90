!| returns unicode character category
submodule(mod_utf8f) mod_utf8f_category
  implicit none
contains
  pure elemental module function utf8f_category(s) result(res)
    character(*), intent(in) :: s
    character(2)             :: res
    integer                  :: c
    res = ""
    c = codepoint(s)
    if (c < 1) return
    call get_utf8f_category(c, res)
  end function utf8f_category
!
  pure subroutine get_utf8f_category(codepoint, res)
    integer, intent(in)         :: codepoint
    character(2), intent(inout) :: res
    include "category_table.h"
    integer                     :: ind
    call binary_search(codepoint, 1, N_TABLE, N_TABLE, &
   &                   INDEX_TABLE, ind)
    res = table(ind)
  end subroutine get_utf8f_category
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
end submodule mod_utf8f_category

