# Cinnadef

1. Prompts user to change root password
2. Patches VSFTPD to remove known vulnerability
3. Hardens SSH configuration
  - Disables root SSH
  - Whitelist only public and greyhats accounts
  - Enable public key authentication
  - Enforces public key authentication for greyhats account
  - Configure chroot jail for public users
4. Hardens FTP configuration
  - Enforce a user list (which has only public)
  - Configure chroot jail for public users
5. Creates a chroot jail for public users
6. Makes important files immutable
7. Adds a greyhats user
8. Sets up IP tables specific to the services required in CDDC
9. Performs file integrity monitoring and restoration on selected files

To harden, run `harden_system.sh`
