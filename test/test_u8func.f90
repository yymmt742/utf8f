program main
  use mod_utf8f
  implicit none
  if (LEN('abcde') /= 5) ERROR stop
  if (utf8f_len('abcde') /= 5) ERROR stop
  if (utf8f_len('あいうえお') /= 5) ERROR stop
  if (utf8f_len('abcdeあいうえお') /= 10) ERROR stop
  if (utf8f_len('▆▆') /= 2) ERROR stop
  if (utf8f_nbyte('a') /= LEN('a')) ERROR stop
  if (utf8f_nbyte('い') /= LEN('い')) ERROR stop
  if (utf8f_nbyte('▆') /= LEN('▆')) ERROR stop
end program main

