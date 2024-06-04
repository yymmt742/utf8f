[![CI](https://github.com/yymmt742/utf8f/actions/workflows/ci.yml/badge.svg)](https://github.com/yymmt742/utf8f/actions/workflows/ci.yml)

<!-- PROJECT LOGO -->
<br />
<div align="center">
<h3 align="center">utf8f</h3>
  <p align="center">
    Fortran utf-8 functions
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

## About The Project

utf8f provides a set of functions useful for handling utf-8 strings in fortran.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started
### Prerequisites

* gcc >= 9.4.0
* gfortran >= 9.4.0
* cmake >= 3.9

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/yymmt742/utf8f
   ```
2. Build fortran library
   ```sh
   mkdir build && cd build
   cmake ..
   make install
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Usage

   ```fortran
      program main
      use mod_utf8f
      implicit none
        print*, utf8f_len("abcde") ! = 5
        print*, utf8f_len("あいうえお") ! = 5
        print*, utf8f_codepoint("あ") ! = 12354 (0x3042)
        print*, utf8f_width("漢") ! = 2
      end program main
   ```

   The following functions are availableThe following functions are available.

  | Function                | Retrun value | Arguments                                   | Description                                                                                                  |
  | ----------------------- | ------------ | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
  | utf8f_len(s)            | integer      | s character(\*)                             | Returns the number of characters in a string. (Unlike the built-in LEN, this is not byte-length.)            |
  | utf8f_codepoint(s)      | integer      | s character(\*)                             | Returns the Unicode code point of the first character in string s.                                           |
  | utf8f_width(s, is_CJK)  | integer      | s character(\*), is_CJK (logical, optional) | Returns the character width displayed in the console. (Based on East Asian Width in Unicode Standard Annex.) |
  | utf8f_category(s)       | character(2) | s character(\*)                             | Returns the Unicode General category.                                                                        |
  | utf8f_easta_property(s) | character(2) | s character(\*)                             | Returns the Unicode East Asian Width property.                                                               |

  The data contained in this database is compiled from the [UCD version 15.1.0](https://www.unicode.org/Public/15.1.0/ucd/).

  For details, see the [Unicode Character Database](https://www.unicode.org/ucd/).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

YYMMT742 - yymmt@kuchem.kyoto-u.ac.jp

<p align="right">(<a href="#readme-top">back to top</a>)</p>

