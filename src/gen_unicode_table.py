import sys

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


def width(sp1, sp2):
    if sp2 == "Me" or sp2 == "Mn" or sp2 == "Cf" or sp2 == "Cc":
        return 0
    elif sp2 == "Cs":
        return 2
    elif sp1 == "F" or sp1 == "W":
        return 2
    elif sp1 == "A":
        return 2
    elif sp1 == "N" and (sp2 == "Zl" or sp2 == "Zp"):
        return 1
    else:
        return -1


"""
for ft in fold_table:
    w = width(ft[2], ft[3])
    print(f"{ft[0]:04x} {ft[1]:04x} {ft[2:4]} {w}")
"""

frac_table = [[-1, ""]]
for ft in fold_table:
    if frac_table[-1][1] != ft[2]:
        frac_table += [[ft[0], ft[2]]]

east_table = [[-1, ""]]
for ft in fold_table:
    if east_table[-1][1] != ft[2]:
        east_table += [[ft[0], ft[2]]]

width_table = [[-1, -1, -1]]
for ft in fold_table:
    w = width(ft[2], ft[3])
    if width_table[-1][1] != w:
        width_table += [[ft[0], w]]

print(frac_table)
print(east_table)
print(width_table)
"""
for wt in frac_table:
    print(f"{wt[0]:04x} {wt[1]}")
for wt in east_table:
    print(f"{wt[0]:04x} {wt[1]}")
for wt in width_table:
    print(f"{wt[0]:04x} {wt[1]}")
"""
