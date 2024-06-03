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
