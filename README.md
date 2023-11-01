# dotfiles
![interface](screenshots/interface.png)

# Configuration
- NVME Drive (480GB) with Windows 10
- External SSD (480GB) with Arch Linux
- KVM/QEMU setup with NVIDIA GPU passthrough
- Hyperland WM (Wayland)

# How I use my system
While in Arch Linux, If I want to play games I boot into my windows 10 virtualized environment by passing through my NVIDIA GPU. I use my Intel iGPU for my wayland session so I can have both environments simultaneously running. This makes switching super easy! Due to this setup, I tend to use my windows 10 virtual machine for anything GPU intensive.
However, at anytime I can still boot into windows normally because the virtual machine is based on a real NVME drive.

Q&A
- Why do I use windows 10 for games? Because of **anticheat**.
- X11 vs Wayland, my experience? This is hard because so many things work on X11 and are easier. However, wayland eliminates screentearing and is extremely smooth! Ultimately I chose wayland because it's still actively worked on and **Hyperland** :-)
