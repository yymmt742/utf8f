!| returns unicode character width
  pure elemental function utf8f_width(s, is_CJK) result(res)
    character(*), intent(in)      :: s
    logical, intent(in), optional :: is_CJK
    integer                       :: res, c
    res = 0
    c = utf8f_codepoint(s)
    if (c < 1) return
    if (PRESENT(is_CJK)) then
      if (is_CJK) then
        call get_utf8f_width(c, res)
      else
        call get_utf8f_width_CJK(c, res)
      end if
    else
      call get_utf8f_width_CJK(c, res)
    end if
  end function utf8f_width
!
  pure subroutine get_utf8f_width(codepoint, res)
    integer, intent(in)      :: codepoint
    integer, intent(inout)   :: res
    include "width_table.h"
    integer                  :: ind
    call binary_search(codepoint, 1, N_TABLE, N_TABLE, &
   &                   INDEX_TABLE, ind)
    res = table(ind)
  end subroutine get_utf8f_width
!
  pure subroutine get_utf8f_width_CJK(codepoint, res)
    integer, intent(in)      :: codepoint
    integer, intent(inout)   :: res
    include "width_CJK_table.h"
    integer                  :: ind
    call binary_search(codepoint, 1, N_TABLE, N_TABLE, &
   &                   INDEX_TABLE, ind)
    res = table(ind)
  end subroutine get_utf8f_width_CJK
