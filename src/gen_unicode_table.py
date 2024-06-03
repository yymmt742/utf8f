import sys

data_source = "https://www.unicode.org/Public/15.1.0/ucd/EastAsianWidth.txt"


def width(sp1, sp2, is_CJK):
    if sp2 == "Cf" or sp2 == "Cc" or sp2 == "Cs" or sp2 == "Co":
        return 0
    elif sp1 == "F" or sp1 == "W":
        return 2
    elif sp1 == "A":
        return 2 if is_CJK else 1
    elif sp1 == "Na" or sp1 == "H":
        return 1
    elif sp1 == "N" and (
        sp2 == "Lu"
        or sp2 == "Ll"
        or sp2 == "Lt"
        or sp2 == "Lm"
        or sp2 == "Pi"
        or sp2 == "Pf"
        or sp2 == "Po"
        or sp2 == "Zs"
        or sp2 == "Zl"
        or sp2 == "Zp"
    ):
        return 1
    elif sp1 == "N" and (
        sp2 == "Pd"
        or sp2 == "L&"
        or sp2 == "Mn"
        or sp2 == "Mc"
        or sp2 == "Me"
        or sp2 == "No"
        or sp2 == "Nd"
        or sp2 == "Nl"
        or sp2 == "Lo"
        or sp2 == "Ps"
        or sp2 == "Pe"
        or sp2 == "Cd"
        or sp2 == "Cf"
        or sp2 == "Sm"
        or sp2 == "Sc"
        or sp2 == "Sk"
        or sp2 == "So"
    ):
        return 2
    else:
        return 0


def to_f90_arrayconstructer(vardef, var, table, nb: int = 5):
    sep = ", &\n  "
    return (
        vardef
        + var
        + "[ &\n"
        + "  "
        + sep.join(
            [
                ", ".join([t for t in table[i : i + nb]])
                for i in range(1, len(table), nb)
            ]
        )
        + "]\n"
    )


def write_chr_table(path, table):
    with open(path, "w") as f:
        n = len(table) - 1
        l = max([len(t[1]) for t in table[1:]])
        f.write("! Generated from " + data_source + "\n")
        f.write(f"  integer, parameter            :: N_TABLE = {n}\n")
        f.write(f"  integer, parameter            :: L_TABLE = {l}\n")
        f.write(
            to_f90_arrayconstructer(
                "  integer, parameter            :: ",
                "index_table(N_TABLE) = ",
                [str(ft[0]).rjust(6) for ft in table],
                10,
            ),
        )
        f.write(
            to_f90_arrayconstructer(
                "  character(L_TABLE), parameter :: ",
                "table(N_TABLE) = ",
                ['"' + str(ft[1]).ljust(l) + '"' for ft in table],
                20,
            ),
        )


def write_int_table(path, table):
    with open(path, "w") as f:
        n = len(table) - 1
        f.write("! Generated from " + data_source + "\n")
        f.write(f"  integer, parameter            :: N_TABLE = {n}\n")
        f.write(
            to_f90_arrayconstructer(
                "  integer, parameter            :: ",
                "index_table(N_TABLE) = ",
                [str(ft[0]).rjust(6) for ft in table],
                10,
            ),
        )
        f.write(
            to_f90_arrayconstructer(
                "  integer, parameter            :: ",
                "table(N_TABLE) = ",
                [str(ft[1]).rjust(2) for ft in table],
                20,
            ),
        )


with open(sys.argv[1]) as f:
    fold_table = [[-1, -1, "", ""]]
    for l in f:
        if len(l) == 0:
            continue
        if l[0] == "#":
            continue
        s = l.split(";")
        if len(s) < 2:
            continue
        codepoints = list(
            map(lambda x: int("0x" + x, 0), list(map(str.strip, s[0].split(".."))))
        )
        if len(codepoints) == 1:
            codepoints += codepoints
        spec = s[1].split()[0:3:2]
        if fold_table[-1][2] == spec[0] and fold_table[-1][3] == spec[1]:
            if fold_table[-1][1] + 1 == codepoints[0]:
                fold_table[-1][1] = codepoints[1]
            else:
                fold_table += [
                    [fold_table[-1][1] + 1, codepoints[0] - 1, "", ""],
                    [codepoints[0], codepoints[1], spec[0], spec[1]],
                ]
        else:
            if fold_table[-1][1] + 1 == codepoints[0]:
                fold_table += [[codepoints[0], codepoints[1], spec[0], spec[1]]]
            else:
                fold_table += [
                    [fold_table[-1][1] + 1, codepoints[0] - 1, "", ""],
                    [codepoints[0], codepoints[1], spec[0], spec[1]],
                ]

category_table = [[-1, ""]]
for ft in fold_table[1:]:
    if category_table[-1][1] != ft[3]:
        category_table += [[ft[0], ft[3]]]

east_table = [[-1, ""]]
for ft in fold_table[1:]:
    if east_table[-1][1] != ft[2]:
        east_table += [[ft[0], ft[2]]]

width_table = [[-1, -1]]
for ft in fold_table[1:]:
    w = width(ft[2], ft[3], False)
    if width_table[-1][1] != w:
        width_table += [[ft[0], w]]

width_CJK_table = [[-1, -1]]
for ft in fold_table[1:]:
    w = width(ft[2], ft[3], True)
    if width_CJK_table[-1][1] != w:
        width_CJK_table += [[ft[0], w]]

write_chr_table("category_table.h", category_table)
write_chr_table("easta_property_table.h", east_table)
write_int_table("width_table.h", width_table)
write_int_table("width_CJK_table.h", width_CJK_table)
