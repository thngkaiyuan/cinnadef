#!/bin/bash

PATCH_DIR='./patch'

# Patch Bash against shellshock
/bin/cp -f $PATCH_DIR/bash /bin/bash

# Change root default password
passwd

# Patch VSFTPD
/bin/cp -f $PATCH_DIR/vsftpd `which vsftpd`

# Startup scripts
/bin/cp -f $PATCH_DIR/rc.local /etc/rc.d/

# Configure SSH
/bin/cp -f $PATCH_DIR/sshd_config /etc/ssh/

# Configure FTP
/bin/cp -f $PATCH_DIR/vsftpd.conf /etc/
/bin/cp -f $PATCH_DIR/vsftpd.allowed_users /etc/

# Create Chroot
mkdir -p /home/chroot/{bin,dev,home/public,lib}
cp -p /bin/* /home/chroot/bin
cp -p /lib/lib* /home/chroot/lib
cp -p /lib/ld-linux.so.2 /home/chroot/lib

# Create devices in chroot
mknod /home/chroot/dev/null c 1 3
mknod /home/chroot/dev/zero c 1 5
chmod 0666 /home/chroot/dev/*

# Copy the flag over
cp /home/public/file /home/chroot/home/public
chmod 644 /home/chroot/home/public/file

# Add greyhats user
useradd greyhats -p ***REMOVED*** -G wheel
mkdir /home/greyhats/.ssh
chown greyhats:greyhats /home/greyhats/.ssh
chmod 700 /home/greyhats/.ssh
cp ./keys/authorized_keys /home/greyhats/.ssh/
chmod 644 /home/greyhats/.ssh/authorized_keys

# Configure IPTables
./setup_iptables.sh

# Add files to be monitored
(cd filemon && ./monitor_files.py /home/chroot/home/public/file)
(cd filemon && ./monitor_files.py /var/www/html/index.html)
(cd filemon && ./monitor_files.py /srv/www/htdocs/index.html)

# Start file monitoring
./start_filemon.sh &

# Clean up files
rm -rf ./keys ./patch

# Set proper permissions
chmod 700 start_filemon.sh setup_iptables.sh harden_system.sh filemon/
chmod 600 ./filemon/tamper_log ./filemon/monitored_files
chmod 100 ./filemon/monitor_files.py ./filemon/check_files.py

# Make files immutable
chattr +i /etc/passwd ./filemon/monitor_files.py ./filemon/check_files.py

echo "Done."
echo "Do check if there are any other sensitive files that needs to be moved."
