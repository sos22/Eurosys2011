#! /usr/bin/env python

import sys
import math

rows = []
for l in sys.stdin.xreadlines():
    w = l.split()
    name = w[0]
    rows.append(map(float, w[1:]))

def transpose(rows):
    width = len(rows)
    height = len(rows[0])
    columns = [[99]] * height
    for i in xrange(height):
        columns[i] = [0] * width
    for x in xrange(width):
        for y in xrange(height):
            columns[y][x] = rows[x][y]
    return columns

columns = transpose(rows)
def mean(x):
    return sum(x)/len(x)
def sd(x):
    m = mean(x)
    return math.sqrt(sum([i * i for i in x])/len(x) - m * m)

means = map(mean, columns)
sds = map(sd, columns)

norm_factor = means[-1]
means = [x/norm_factor for x in means]
sds = [x/norm_factor for x in sds]

print name,
print "\t",
print " ".join(map(str, means))
print name,
print "\t",
print " ".join(map(str, sds))
