#! /usr/bin/env python

# Computer mean, variance, sd, min, and max of a set of numbers

import sys
import math

l = sys.stdin.readline()
min = float(l)
max = min
sum = min
sum2 = min * min
n = 1
while True:
    l = sys.stdin.readline()
    if l == "":
        break
    x = float(l)
    sum = sum + x
    sum2 = sum2 + x * x
    n = n + 1
    if x > max:
        max = x
    if x < min:
        min = x

mean = sum / n
var = (sum2 / n) - (mean * mean)
if var >= 0: # Watch for rounding error
    sd = math.sqrt(var)
else:
    sd = 0
    
print "%d samples\nmin %f\nmax %f\nmean %f\nvariance %f\nsd %f\nsum %f" % (n,min,max,mean,var,sd,sum)
