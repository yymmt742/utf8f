import sys

"""
table = ["" for i in range(1114110)]

with open(sys.argv[1]) as f:
    for l in f:
        s = l.split(";")[0:3:2]
        codepoint = int("0x" + s[0], 0)
        table[codepoint] = s[1]
"""

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
        """
        if spec[] == "N":
            continue
        if len(codepoints) == 1:
            table[codepoints[0]] = spec
        else:
            for codepoint in range(codepoints[0], codepoints[1] + 1):
                table[codepoint] = spec
        """
        if fold_table[-1][2] == spec[0] and fold_table[-1][3] == spec[1]:
            if fold_table[-1][1] + 1 == codepoints[0]:
                fold_table[-1][1] = codepoints[1]
            else:
                fold_table += [[codepoints[0], codepoints[1], spec[0], spec[1]]]
        else:
            fold_table += [[codepoints[0], codepoints[1], spec[0], spec[1]]]
"""
spec = ""
ispc = -1
fold_table = []
for i, t in enumerate(table):
    if t != spec:
        if ispc >= 0:
            fold_table += [[f"{ispc:04x}", f"{i - 1:04x}", spec]]
        spec = t
        ispc = i
        continue
"""


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


for ft in fold_table:
    w = width(ft[2], ft[3])
    print(f"{ft[0]:04x} {ft[1]:04x} {ft[2:4]} {w}")
