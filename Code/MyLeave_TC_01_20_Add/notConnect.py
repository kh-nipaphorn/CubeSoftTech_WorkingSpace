import os
# os.system("netsh interface show interface")
# def enable():
#     os.system("netsh interface set interface 'Wi-Fi' enabled")

def disable():
    os.system("ipconfig /release Wi-Fi")
disable()

# run as admin
# netsh interface set interface name='Wi-Fi' admin=DISABLED


