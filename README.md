# Cinnadef

Defence tools for CDDC

1. Patches bash against shellshock
2. Prompts user to change root password
3. Patches VSFTPD to remove known vulnerability
4. Hardens SSH configuration
  - Disables root SSH
  - Whitelist only public and greyhats accounts
  - Enable public key authentication
  - Enforces public key authentication for greyhats account
  - Configure chroot jail for public users
5. Hardens FTP configuration
  - Enforce a user list (which has only public)
  - Configure chroot jail for public users
6. Creates a chroot jail for public users
7. Makes important files immutable
8. Adds a greyhats user
9. Sets up IP tables specific to the services required in CDDC
10. Performs file integrity monitoring and restoration on selected files
  - Works best for small files
11. ARP monitoring script that does active and passive detection of ARP poisoning
  - Checks if any physical address is claiming to be more than one IP address by doing an active ARP ping and by scanning through the machine's ARP table
  - TODO: Also check if an IP address is claimed by more than one physical address (possible sign of ARP poisoning)
12. Cleans up after itself and sets proper permissions on its scripts

To harden, run `harden_system.sh`
