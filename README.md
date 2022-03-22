***This Kernel is underdevelopement some features might and might not work for Nethunter***

LeEco Le 2 (s2) Nethunter Kernel     
===============================


The LeEco Le 2 is a smartphone from LeEco or LeMobile Information Technology Co. Ltd.



Device configuration for s2
=====================================

Basic   | Spec Sheet
-------:|:-------------------------
CHIPSET | Qualcomm MSM8976 Snapdragon 652
CPU     | Quad-core 1.4 GHz Cortex-A53 & Quad-core 1.8 GHz Cortex-A72
GPU     | Adreno 510
Memory/RAM  | 3 GB
Storage | 32 GB
Battery | 3000 mAh (Non-Removable)
Dimensions | 151.1 x 74.2 x 7.5 mm
Display | 1080 x 1920 pixels 5.5"
Rear Camera  | 16.0 MP
Front Camera | 8.0 MP
Release Date | June 2016





# Build Guide:
--------

# Download, Prepare and Compile the Kernel
--------

- Download Kernel Sources

```
git clone --recursive https://github.com/kartik01001/nethunter_s2.git -b master
```


- Change Directory to Nethunter Kernel Directory and Make Output Folder

```
cd nethunter_s2
```


- Compile the Kernel and downloading toolchain

For Toolchain:
```
./build_menu.sh
Press Enter to download toolchain
```

For Build:
```
./build_menu.sh
Type 1 and choose nethunter
```
