#!/usr/bin/env bash

layout_keyboard(){
  clear
  echo -e "[ ] - Configurando layout do teclado ABNT2\n"
  sleep 2
  loadkeys br-abnt2
}

font_system(){
  clear
  echo -e "[ ] - Aumentando o tamanho da fonte do sistema\n"
  sleep 2
  setfont lat4-19
}

format_disk(){
  clear
  echo -e "[ ] - Formatando os dicos\n"
  sleep 2
  mkfs.vfat -F32 /dev/sda1
  mkfs.btrfs -f /dev/sda2
}

subvolumes(){
  clear
  echo -e "[ ] - Criando subvolumes em btrfs\n"
  sleep 2
  mount /dev/sda2 /mnt
  btrfs su cr /mnt/@
  btrfs su cr /mnt/@home
  btrfs su cr /mnt/@var
  btrfs su cr /mnt/@snapshots
  chattr +C /mnt/@var
  umount /mnt
}

mount_partitions(){
  clear
  echo -e "[ ] - Montando partições\n"
  sleep 2
  mount -o defaults,compress=zstd,nossd,autodefrag,subvol=@ /dev/sda2 /mnt
  mkdir -p /mnt/boot/efi
  mkdir /mnt/home
  mkdir /mnt/var
  mkdir /mnt/.snapshots
  mount -o defaults,compress=zstd,nossd,autodefrag,subvol=@home /dev/sda2 /mnt/home
  mount -o defaults,compress=zstd,nossd,autodefrag,subvol=@var /dev/sda2 /mnt/var
  mount -o defaults,compress=zstd,nossd,autodefrag,subvol=@snapshots /dev/sda2 /mnt/.snapshots
  mount /dev/sda1 /mnt/boot/efi
}
pacstrap_arch(){
  clear
  echo -e "[ ] - Instalando os pacotes base do Arch Linux\n"
  sleep 2
  pacstrap /mnt base dhcpcd neovim linux-firmware base-devel
  pacman -Sy archlinux-keyring --noconfirm
  pacstrap /mnt base dhcpcd neovim linux-firmware base-devel
}

fstab_gen(){
  clear
  echo -e "[ ] - Gerando o Fstab\n"
  sleep 2
  genfstab /mnt >> /mnt/etc/fstab
}

arch-chroot_enter(){
clear
echo -e "[ ] - Entrando no chroot\n"
sleep 2
arch-chroot /mnt
pacman -S wget --noconfirm
wget -c "https://github.com/ffraanks/arch-chroot/raw/master/arch-chroot.sh" && chmod +x arch-chroot.sh && ./arch-chroot.sh
}

layout_keyboard
font_system
format_disk
subvolumes
mount_partitions
pacstrap_arch
fstab_gen
arch-chroot_enter