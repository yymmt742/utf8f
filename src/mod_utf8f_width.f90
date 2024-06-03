!| returns unicode character width
submodule(mod_utf8f) mod_utf8f_width
  implicit none
contains
  pure elemental module function utf8f_width(s, is_CJK) result(res)
    character(*), intent(in)      :: s
    logical, intent(in), optional :: is_CJK
    integer                       :: res, c
    res = 0
    c = codepoint(s)
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
  pure recursive subroutine binary_search(codepoint, l, u, n_table, index_table, res)
    integer, intent(in)      :: codepoint
    integer, intent(in)      :: l
    integer, intent(in)      :: u
    integer, intent(in)      :: n_table
    integer, intent(in)      :: index_table(n_table)
    integer, intent(inout)   :: res
    if (l == u) return
    res = l + (u - l + 1) / 2
    if (codepoint < index_table(res)) then
      block
        integer :: ul
        res = res - 1
        ul = res
        call binary_search(codepoint, l, ul, n_table, index_table, res)
      end block
    else
      block
        integer :: ll
        ll = res
        call binary_search(codepoint, ll, u, n_table, index_table, res)
      end block
    end if
  end subroutine binary_search
!
end submodule mod_utf8f_width

