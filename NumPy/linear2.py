import numpy as np



A = np.array([
    [1, 2],
    [3, 4]
])

x = np.array([5, 6])


# [1*5 + 2*6,
#  3*5 + 4*6]



y = A @ x
print(y)

print(np.dot(A, x))
