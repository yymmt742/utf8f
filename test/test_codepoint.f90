program main
  use mod_utf8f
  implicit none
  if (utf8f_codepoint('a') /= INT(z"61")) ERROR stop
  if (utf8f_codepoint('あ') /= INT(z"3042")) ERROR stop
  if (utf8f_codepoint('★') /= INT(z"2605")) ERROR stop
  if (utf8f_codepoint('💯') /= INT(z"1F4AF")) ERROR stop
end program main

