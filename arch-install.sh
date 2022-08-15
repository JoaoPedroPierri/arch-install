#!/usr/bin/env bash

# Script archlinux install
# Franklin Souza
# @FranklinTech

format_disk(){
  clear
  echo -e "[!] - Formatando os discos\n"
  sleep 2
  mkfs.vfat -F32 /dev/sda1 
  mkfs.ext4 /dev/sda2 
  mkfs.ext4 /dev/sda3
  mkswap /dev/sda3 
  mkfs.ext4 /dev/sda4 
}

mount_partitions(){
  clear
  echo -e "[!] - Montando as partições\n"
  sleep 2
  mount /dev/sda2 /mnt 
  mkdir -p /mnt/boot/efi && mount /dev/sda1 /mnt/boot/efi 
  mkdir /mnt/home && mount /dev/sda4 /mnt/home 
  swapon /dev/sda3 
}

iwctl_enable(){
  iwctl
  station wlan0 connect <VMVJP>
}

pacstrap_arch(){
  clear
  echo -e "[!] - Instalando os pacotes base do Arch Linux\n"
  sleep 2
  pacstrap /mnt base neovim linux-firmware base-devel
  pacman -Sy archlinux-keyring --noconfirm
  pacstrap /mnt base neovim linux-firmware base-devel
}

fstab_gen(){
  clear
  echo -e "[!] - Gerando o Fstab\n"
  sleep 2
  genfstab /mnt >> /mnt/etc/fstab
}

arch_chroot_enter(){
  clear && echo -e "[!] - ENTRE NO CHROOT DIGITANDO: arch-chroot /mnt"
  sleep 2
}

format_disk
mount_partitions
iwctl_enable
pacstrap_arch
fstab_gen
arch_chroot_enter
