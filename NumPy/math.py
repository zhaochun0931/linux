import numpy as np

a = np.arange(12)
print(a)

b = a.reshape(3,4)
print(b)

c = np.array([10,10,10,10])
print(c)

print(b + c)
print(np.add(b, c))

print(b - c)
print(np.subtract(b, c))

print(b * c)
print(np.multiply(b, c))

print(b / c)
print(np.divide(b, c))
