# Boot2Root

## Write-Up 1

After the vm setup the VM

Scan network to find ip:
`nmap -sP -sn 192.168.56.0/24`


Scan open port for the IP:
`nmap 192.168.56.4`


Detect routes:
`nmap -sV --script=http-enum 192.168.56.4`

```sh
21/tcp  open  ftp        vsftpd 2.0.8 or later
22/tcp  open  ssh        OpenSSH 5.9p1 Debian 5ubuntu1.7 (Ubuntu Linux; protocol 2.0)
80/tcp  open  http       Apache httpd 2.2.22 ((Ubuntu))
|_http-server-header: Apache/2.2.22 (Ubuntu)
143/tcp open  imap       Dovecot imapd
443/tcp open  ssl/http   Apache httpd 2.2.22
| http-enum:
|   /forum/: Forum
|   /phpmyadmin/: phpMyAdmin
|   /webmail/src/login.php: squirrelmail version 1.4.22
|_  /webmail/images/sm_logo.png: SquirrelMail
|_http-server-header: Apache/2.2.22 (Ubuntu)
993/tcp open  ssl/imaps?
Service Info: Host: 127.0.1.1; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 17.18 seconds
```

We can observe:
    
- Ports open:

    21/tcp  open  ftp        vsftpd 2.0.8 or later

    22/tcp  open  ssh        OpenSSH 5.9p1 Debian 5ubuntu1.7 (Ubuntu Linux; protocol 2.0)

    80/tcp  open  http       Apache httpd 2.2.22 ((Ubuntu))

    143/tcp open  imap       Dovecot imapd

    443/tcp open  ssl/http   Apache httpd 2.2.22

    993/tcp open  ssl/imaps?

- 4 Routes on port 443:

    /forum/: Forum

    /phpmyadmin/: phpMyAdmin

    /webmail/src/login.php: squirrelmail version 1.4.22

    /webmail/images/sm_logo.png: SquirrelMail


- Forum:
    We can curl the forum to see

```sh
curl --insecure 'https://192.168.56.4/forum/' | grep href | tr "<>" "\n" | grep href | sed 's/.* href/\
href/g' | cut -d "=" -f2 | sed '/^..*$/!d'
```

```
"themes/default/style.min.css" media
"index.php?mode
"index.php?mode
"themes/default/images/favicon.ico" /
"./" title
"index.php?mode
"index.php?mode
"index.php?mode
"index.php?refresh
"index.php?mode
"index.php?fold_threads
"index.php?toggle_view
"index.php?id
"index.php?mode
"index.php?id
"index.php?mode
"index.php?id
"index.php?mode
"index.php?id
"index.php?id
"index.php?mode
"index.php?id
"index.php?mode
"index.php?mode
"index.php?mode
"http://mylittleforum.net/"
```

From the web browser we can read a topic intitled "Probleme login?"
`https://192.168.56.4/forum/index.php?id=6`

We found inside 2 important data that we cannot guess, a username `lmezard` and a password `!q\]Ej?*5K5cy*AJ`

We can see inside many log about failed connection try
`curl --insecure 'https://192.168.56.4/forum/index.php?id=6' | grep 'Failed password'`

We found a password but doesn't work on ssh

We will try on the webmail service

Doesn't work either

Instead, if we try to login on the forum 

It works for te user `lmezard`

Now we are logged we can see that there is no real difference between the previous situation, exept for the user space

Inside the user spae we found the lmezard's email,that's `laurie@borntosec.net`

We can try to log to the webmail server at `webmail/src/login.php`

It works with the same password

There's a mail with db access

We can connect to the phpmyadmin dashboard

