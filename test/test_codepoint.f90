program main
  use mod_utf8f
  implicit none
  character(512) :: path, line
  integer        :: u, ios, id, codepoint
  call GET_COMMAND_ARGUMENT(1, path)
  open (NEWUNIT=u, FILE=path)
  do
    read (u, '(A)', IOSTAT=ios) line
    if (ios > 0) error stop
    if (ios < 0) exit
    id = INDEX(line, ' ')
    read (line(:id), *) codepoint
    if (utf8f_codepoint(line(id + 1:)) /= codepoint) then
      error stop
    end if
  end do
end program main

