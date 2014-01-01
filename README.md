virtual-box-management
======================

Scripting to manage exporting, importing, and distributing VM images to multiple systems from central master with golden vm image.

================================================================================
If you are looking for Windows VMs to test this out with, some decent images are available at http://modern.ie/.

================================================================================
some notes
as of Mon Dec  9 08:33:29 EST 2013 two workstations (one really slow) took about 10 minutes to publish) clean start and stop on the faster workstation.
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
Running remote commands on windows 7 vm
http://www.virtualbox.org/manual/ch08.html#vboxmanage-guestcontrol

Check your licensing status:
vboxmanage --nologo guestcontrol "GoldImage" execute --username LocalAdmin --password blackburn --wait-exit --wait-stdout  --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '/dlv'
vboxmanage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --username IEUser --password Passw0rd\! --wait-exit --wait-stdout  --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '/dlv'
vboxmanage --nologo guestcontrol "<vm image name>" execute --username IEUser --password <password> --wait-exit --wait-stdout  --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '/dlv'

To release the product key for use elsewhere, use: (Does not seem to be a way to elevate to admin privileges)
vboxmanage --nologo guestcontrol "GoldImage" execute --username LocalAdmin --password blackburn --wait-exit --wait-stdout  --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '/upk'
vboxmanage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --username IEUser --password Passw0rd\! --wait-exit --wait-stdout  --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '-upk'

Update Product key through command line: (Does not seem to be a way to elevate to admin privileges)
vboxmanage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --username IEUser --password Passw0rd\! --wait-exit --wait-stdout  --image 'c:\Windows\System32\wscript.exe' 'c:\\windows\\System32\\slmgr.vbs' '-ipk' '74M4B-BTT8P-MMM3M-64RRJ-JCDDG'

Run IE
VBoxManage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --image "C:\\Program Files\\Internet Explorer\\iexplore.exe" --username IEUser  --wait-exit --password Passw0rd\!

Get IP information
VBoxManage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --image "c:\\windows\\system32\\ipconfig.exe" --username IEUser  --wait-exit --wait-stdout --password Passw0rd\!

Start a command prompt.. does not seem to really work
VBoxManage --nologo guestcontrol "IE10.Win7.For.MacVirtualBox" execute --image "c:\\windows\\system32\\cmd.exe" --username IEUser  --wait-exit --wait-stdout --password Passw0rd\!


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

WMIC computersystem where caption='currentname' rename newname
WMIC computersystem where caption='GoldImage' rename Workstation

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
