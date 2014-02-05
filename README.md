virtual-box-management
======================
Scripting to manage exporting, importing, and distributing VM images
to multiple systems from central master with golden vm image.

If you are looking for Windows VMs to test this out with, some decent
images are available at http://modern.ie/.

================================================================================
TODO:
================================================================================
1. create script to capturing base system information in a screenshot.
   (see: doc/ScreenShot_systeminfo_1.png)
   open command prompt
   maximize command promp or open to standardized size and possition
   run: systeminfo | findstr /B /C:"Host Name" /C:"OS"
   run: slmgr.vbs -dlv
   capture screenshot

2. create guestcontrol helper script based on examples from "Running
   remote commands on windows 7 vm" below.
================================================================================


================================================================================
some notes
================================================================================
As of Mon Dec 9 08:33:29 EST 2013 two workstations (one really slow)
took about 10 minutes to publish) clean start and stop on the faster
workstation.

time ./publish_image.sh ../vmout_2013-35-06_223552.ova

real	9m49.675s
user	0m0.205s
sys	0m0.065s

================================================================================
find users with passwords or passwords not required.
the grep patterns below are for accounts that are locked.
----
sudo cat /etc/shadow | grep -v -e "^[a-z-]*:\*" -e "^[a-z-]*:\!"
----
From Wikipedia: http://en.wikipedia.org/wiki/Passwd
"!" - the account is password Locked, user will be unable to log-in via password authentication but other methods (e.g. ssh key) may be still allowed)[7]
"*LK*" or "*" - the account is Locked, user will be unable to log-in via password authentication but other methods (e.g. ssh key) may be still allowed) [7]
================================================================================

# openssh needs to be setup on host box to support publishing
# https://help.ubuntu.com/10.04/serverguide/openssh-server.html

================================================================================
Republishing Windows VMs from a master image
http://answers.microsoft.com/en-us/windows/forum/windows_7-windows_install/republishing-windows-vms-from-a-master-image/1e84edcf-3e0a-4716-96be-d134d8b95370

Check your licensing status:
slmgr.vbs -dlv
(see: doc/ScreenShot_slmgr.vbs_1.png)

To release the product key for use elsewhere, use:
slmgr.vbs -upk
requires administrator privileges
(see: doc/ScreenShot_slmgr.vbs_2.png)
run with administrator privileges
(see: doc/ScreenShot_slmgr.vbs_3.png)
licensing status after release
(see: doc/ScreenShot_slmgr.vbs_4.png)

Update Product key through command line:
slmgr.vbs -ipk #####-#####-#####-#####-#####
Expired test key:
Microsoft Windows 7 Enterprise,74M4B-BTT8P-MMM3M-64RRJ-JCDDG
slmgr.vbs -ipk 74M4B-BTT8P-MMM3M-64RRJ-JCDDG

requires administrator privileges
(see: doc/ScreenShot_slmgr.vbs_5.png)
run with administrator privileges
(see: doc/ScreenShot_slmgr.vbs_6.png)
licensing status after release
(see: doc/ScreenShot_slmgr.vbs_7.png)
================================================================================
Running remote commands with psexec

c:\software\PSTools\psexec -h c:\Windows\System32\wscript.exe c:\\windows\\System32\\slmgr.vbs /upk
================================================================================
Running remote commands on windows 7 vm
http://www.virtualbox.org/manual/ch08.html#vboxmanage-guestcontrol

Check your licensing status:
vboxmanage --nologo guestcontrol "<vm image name>" execute --username <username> --password <password> --wait-exit --wait-stdout --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '/dlv'
vboxmanage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --username IEUser --password Passw0rd\! --wait-exit --wait-stdout --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '/dlv'

To release the product key for use elsewhere, use: (Does not seem to be a way to elevate to admin privileges to make this work.)
vboxmanage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --username IEUser --password Passw0rd\! --wait-exit --wait-stdout --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '-upk'

Update Product key through command line: (Does not seem to be a way to elevate to admin privileges to make this work.)
vboxmanage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --username IEUser --password Passw0rd\! --wait-exit --wait-stdout --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '-ipk' '74M4B-BTT8P-MMM3M-64RRJ-JCDDG'

Run IE
VBoxManage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --username IEUser --password Passw0rd\! --wait-exit --wait-stdout --image "C:\\Program Files\\Internet Explorer\\iexplore.exe"

Get IP information
VBoxManage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --username IEUser --password Passw0rd\! --wait-exit --wait-stdout --image "c:\\windows\\system32\\ipconfig.exe"

Start a command prompt.. does not seem to really work
VBoxManage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --username IEUser --password Passw0rd\! --wait-exit --wait-stdout --image "c:\\windows\\system32\\cmd.exe"


================================================================================

================================================================================
How do I run a program as administrator on Win7 guest?
https://forums.virtualbox.org/viewtopic.php?f=2&t=56253
Execute Windows applications remotely using SSH and PSExec
http://nonvox.blogspot.com/2011/02/execute-windows-applications-remotely.html
So we are back to cygwin for remote execution!
Seems like too much to update license keys.

================================================================================


================================================================================
Renaming Windows 7 from command line.
http://www.windows-commandline.com/change-computer-name-command-line/
Reboot is require to make new name take effect.

WMIC computersystem where caption='currentname' rename newname
WMIC computersystem where caption='newname' rename 'GoldImage'
WMIC computersystem where caption='GoldImage' rename Workstation
WMIC computersystem where caption='GoldImage' rename TestImage
================================================================================

================================================================================
Find windows OS version from command line
http://www.windows-commandline.com/find-windows-os-version-from-command/

systeminfo | findstr /C:"OS"
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
================================================================================

================================================================================
Posts
================================================================================
Republishing Windows VMs from a master image
http://answers.microsoft.com/en-us/windows/forum/windows_7-windows_install/republishing-windows-vms-from-a-master-image/1e84edcf-3e0a-4716-96be-d134d8b95370

--
Lee Blackburn asked on  December 7, 2013

I am working on publishing to multiple workstations (12-15) from a central Windows 7 (maybe 8.1) VM image.

Is it possible to install a single license key on the master image and then change the key on each workstation after pushing out the new image?
When updating the master image and republishing, can the existing workstation keys be reused and updated again?

Secondly, is there a way to script updating the activation keys?

There was a similar question in the thread below.

http://answers.microsoft.com/en-us/windows/forum/windows_7-windows_install/can-i-use-the-same-windows-7-pro-license-key-on-a/15dea56a-e089-4b30-9016-1f400f1622ad

Regards,
Lee Blackburn

--
Andre Da Costa replied on  December 7, 2013

You can change the product key using the following method:

Update Product key through command line:

slmgr.vbs -ipk #####-#####-#####-#####-#####

####-.... replace that with your product key.

Check your licensing status:

slmgr.vbs -dlv

To release the product key for use elsewhere, use:

slmgr.vbs -upk. However, if you have a problem with the UPK option, look at this Vista page http://support.microsoft.com/kb/947241

--
Lee Blackburn replied on  December 29, 2013

Thanks Andre.

That does the trick from the command prompt on the system.
The release and update switches require the command prompt to be started with administrator privileges.


I was able to the licensing status check work with guest control with VirtualBox.
vboxmanage --nologo guestcontrol "<vm image name>" execute --username IEUser --password <password> --wait-exit --wait-stdout  --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '/dlv'

I have not found a way to run administrator level commands through VirtualBox guest control.

I am looking at some other options such as setting up an ssh server and using psexec based on the posts below.  I am still not sure this will achieve the elevated privileges that are required.

How do I run a program as administrator on Win7 guest?
https://forums.virtualbox.org/viewtopic.php?f=2&t=56253

Execute Windows applications remotely using SSH and PSExec
http://nonvox.blogspot.com/2011/02/execute-windows-applications-remotely.html


================================================================================
Getting VirtualBox up and running on Chromebook with Crouton.
http://www.howtogeek.com/162120/how-to-install-ubuntu-linux-on-your-chromebook-with-crouton/
https://github.com/dnschneid/crouton/blob/master/README.md

Using and Acer C710-2487 with 4GB of RAM and 4GB Memory 320GB HDD.  ~20GB of the HDD seem to be missing or reserved for something that is not visable using df on the shell.

I used Crouton to install Ubuntu’s Unity desktop.  This seems to setup a very bare bones ubuntu install of 12.04 TLS code name precise on an intel chromebook.  Only the Xterm is available and not the terminal app.  The Ubuntu Software Center needs to be added via apt-get.  Screenshots do not seem to work.

Crouton gets Ubuntu up and running ok after a little hick up.  Looks like the inital copy into /var/run/crouton had some issue and had to delete the directory tree and start over.  There seem to be some leftover files in /tmp/crouton.* from the failed attempts.  The crouton installer does build a temporary directory in /tmp named crouton.<random> to preform the download and install. 

Installing VirtualBox.
This was not a straghtforward install as with a standard Ubuntu 12.04 TLS system.
Pulled down the 1386 virtualbox package from https://www.virtualbox.org/wiki/Linux_Downloads
http://download.virtualbox.org/virtualbox/4.3.6/virtualbox-4.3_4.3.6-91406~Ubuntu~precise_i386.deb
attempt to install virtualbox using
sudo dpkg -i irtualbox-4.3_4.3.6-91406~Ubuntu~precise_i386.deb

had to run the fix flag for apt-get
sudo apt-get -f install

This fixed a lot of broken dependancies and allowed emacs to be installed.

rerunning virtualbox package install produced less errors.
sudo dpkg -i irtualbox-4.3_4.3.6-91406~Ubuntu~precise_i386.deb
now there are dependancy problems with only libdevmapper1.02.1, libpython2.7, and psmisc

running again to try to correct
sudo apt-get -f install

VirtualBox still seems to have issue running on the ChromeBook under Crouton.  I went with plan B and using Chrome Remote Desktop to connect to VMs running on a remote server.