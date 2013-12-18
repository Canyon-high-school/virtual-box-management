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
