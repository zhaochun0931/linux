import numpy as np

a = np.arange(10)

print(a)


print(a[2:])

print(a[:5])

print(a[::3])



s = a[2:10:3]

print(s)

s = slice(2,10,3)

print(a[s])
