import numpy as np

a = np.array([1, 2, 3, 4, 5, 6])

print(a)


b = a.reshape(2, 3)
print(b)


c = a.reshape(3,2)
print(c)



d = np.arange(24)
e = d.reshape(2, 3, 4)
print(e)
