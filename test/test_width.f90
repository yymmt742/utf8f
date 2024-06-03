program main
  use mod_utf8f
  implicit none
  character(512) :: path, line
  integer        :: u, ios, id1, id2, codepoint, width
  call GET_COMMAND_ARGUMENT(1, path)
  open (NEWUNIT=u, FILE=path)
  do
    read (u, '(A)', IOSTAT=ios) line
    if (ios > 0) error stop
    if (ios < 0) exit
    id1 = INDEX(line, ' ')
    id2 = id1 + INDEX(line(id1 + 1:), ' ')
    read (line(:id1), *) codepoint
    read (line(id1:id2), *) width
    if (utf8f_width(line(id2 + 1:)) /= width) then
      print '(z6.6,2I8,1X,A)', utf8f_codepoint(line(id2 + 1:)), width, utf8f_width(line(id2 + 1:))
      error stop
    end if

  end do
end program main

