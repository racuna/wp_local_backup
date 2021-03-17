# SCP without passwords
Author: Roberto Acuña

```
local$ ssh-keygen -t dsa
local$ scp ~/.ssh/id_dsa.pub remote
local$ ssh username@remote
remote$ cat ~/id_dsa.pub >> ~/.ssh/authorized_keys
remote$ chmod 644 ~/.ssh/authorized_keys
remote$ exit
local$ ssh username@remote
```


Also you can use ```ssh-copy-id``` (if you have it installed):

```local$ ssh-copy-id -i ~/.ssh/id_rsa.pub remote-host```

After this you should try if it is working, because some servers have this disabled for security reasons.
