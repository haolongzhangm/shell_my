import os
import time

os.system("cp ./core.10085 ./core.big")

while True:
    new_size = os.path.getsize('./core.10085')
    old_size = os.path.getsize('./core.big')

    print('new_size = %d, old_size = %d' % (new_size, old_size))

    if new_size > old_size:
        print('triger copy!!!')
        os.system("cp ./core.10085 ./core.big")
    time.sleep(0.1)
