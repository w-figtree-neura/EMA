taskkill /f /im explorer.exe
ping -n 1 127.0.0.1 > NUL 2>&1
start explorer.exe