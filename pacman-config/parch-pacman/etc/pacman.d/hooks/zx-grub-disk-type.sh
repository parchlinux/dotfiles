#!/bin/bash

# Check if the system is running in UEFI mode
if [[ -d "/sys/firmware/efi" ]]; then
    # UEFI mode detected
    echo "UEFI system detected. Reinstalling GRUB for UEFI..."
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Parch
else
    # Legacy (BIOS) mode detected
    echo "Legacy (BIOS) system detected. Reinstalling GRUB for BIOS..."

    # Find the primary disk for MBR installations
    primary_disk=$(lsblk -o NAME,SIZE,MOUNTPOINT -nl | awk '$3=="/" {print $1}' | sed 's/[0-9]//g')

    if [[ -n "$primary_disk" ]]; then
        grub-install --target=i386-pc --recheck "/dev/$primary_disk"
    else
        echo "Error: Unable to determine primary disk. Check your configuration."
        exit 1
    fi
fi

grub-mkconfig -o /boot/grub/grub.cfg
