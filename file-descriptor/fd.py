import time

with open("demo.txt", "w") as fd:
    print("File descriptor:", fd.fileno())
    fd.write("Hello from Python!\n")
    time.sleep(60)  # Sleep for 60 seconds before closing the file
