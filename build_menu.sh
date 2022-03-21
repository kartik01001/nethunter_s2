#!/bin/bash
# Afaneh menu V1.0 

# Variables
DIR=`readlink -f .`;
PARENT_DIR=`readlink -f ${DIR}/..`;

CHIPSET_NAME=msm8976
ARCH=arm64

CROSS_COMPILE=$PARENT_DIR/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_MAKE_ENV="LOCALVERSION=-SiameseCat"

DTS_DIR=$(pwd)/out/arch/$ARCH/boot/dts

# Color
ON_BLUE=`echo -e "\033[44m"`	# On Blue
RED=`echo -e "\033[1;31m"`	# Red
BLUE=`echo -e "\033[1;34m"`	# Blue
GREEN=`echo -e "\033[1;32m"`	# Green
Under_Line=`echo -e "\e[4m"`	# Text Under Line
STD=`echo -e "\033[0m"`	# Text Clear
 
# Functions
pause(){
  read -p "${RED}$2${STD}Press ${BLUE}[Enter]${STD} key to $1..." fackEnterKey
}

variant(){
  findconfig=""
  findconfig=($(ls arch/arm64/configs/lineage_* 2>/dev/null))
  declare -i i=1
  shift 2
  for e in "${findconfig[@]}"; do
    echo "$i) $(basename $e | cut -d'_' -f2)"
    i=i+1
  done
  echo ""
  read -p "Select variant: " REPLY
  i="$REPLY"
  if [[ $i -gt 0 && $i -le ${#findconfig[@]} ]]; then
    export v="${findconfig[$i-1]}"
    export VARIANT=$(basename $v | cut -d'_' -f2)
    echo ${VARIANT} selected
    pause 'continue'
  else
    pause 'return to Main menu' 'Invalid option, '
    . $DIR/build_menu
  fi
}

toolchain(){
  if [ ! -d $PARENT_DIR/aarch64-linux-android-4.9 ]; then
    pause 'clone Toolchain aarch64-linux-android-4.9 cross compiler'
    git clone -b lineage-18.1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 $PARENT_DIR/aarch64-linux-android-4.9
    . $DIR/build_menu
  fi
}

clean(){
  echo "${GREEN}***** Cleaning in Progress *****${STD}";
  make -j$(nproc) CROSS_COMPILE=$CROSS_COMPILE ARCH=arm64 clean 
  make -j$(nproc)  CROSS_COMPILE=$CROSS_COMPILE ARCH=arm64 mrproper
  [ -d "out" ] && rm -rf out
  echo "${GREEN}***** Cleaning Done *****${STD}";
  pause 'continue'
 }

build(){
  variant
  echo "${GREEN}***** Compiling kernel *****${STD}"
  [ ! -d "out" ] && mkdir out
  make -j$(nproc) O=out/ ARCH=arm64 CROSS_COMPILE=$CROSS_COMPILE lineage_${VARIANT}_defconfig
  time make -j$(nproc) O=out/ ARCH=arm64 CROSS_COMPILE=$CROSS_COMPILE 

  [ -e out/arch/arm64/boot/Image.gz ] && cp out/arch/arm64/boot/Image.gz $(pwd)/out/Image.gz
  if [ -e out/arch/arm64/boot/Image.gz-dtb ]; then
    cp out/arch/arm64/boot/Image.gz-dtb $(pwd)/out/Image.gz-dtb

    echo "${GREEN}***** Ready to Roar *****${STD}";
    pause 'continue'
  else
    pause 'return to Main menu' 'Kernel STUCK in BUILD!, '
  fi
}

anykernel3(){
  if [ ! -d $PARENT_DIR/AnyKernel3 ]; then
    pause 'clone AnyKernel3 - Flashable Zip Template'
    git clone https://github.com/Play4NoobWin/AnyKernel3.git $PARENT_DIR/AnyKernel3
  fi
  variant
  [ -e $PARENT_DIR/${VARIANT}_kernel.zip ] && rm $PARENT_DIR/${VARIANT}_kernel.zip
    cp $(pwd)/out/arch/arm64/boot/Image.gz-dtb $PARENT_DIR/AnyKernel3/Image.gz-dtb
  cd $PARENT_DIR/AnyKernel3
  zip -r9 $PARENT_DIR/${VARIANT}_kernel.zip * -x .git README.md *placeholder
  cd $DIR
  pause 'continue'
}

# Run once
toolchain
llvm

# Show menu
show_menus() {
  clear
  echo "${ON_BLUE} B U I L D - M E N U ${STD}"
  echo "1. ${Under_Line}B${STD}uild"
  echo "2. ${Under_Line}C${STD}lean"
  echo "3. Make ${Under_Line}f${STD}lashable zip"
  echo "4. E${Under_Line}x${STD}it"
}

# Read input
read_options(){
  local choice
  read -p "Enter choice [ 1 - 4] " choice
  case $choice in
    1|b|B) build ;;
    2|c|C) clean ;;
    3|f|F) anykernel3;;
    4|x|X) exit 0;;
    *) pause 'return to Main menu' 'Invalid option, '
  esac
}

# Trap CTRL+C, CTRL+Z and quit singles
trap '' SIGINT SIGQUIT SIGTSTP
 
# Step # Main logic - infinite loop
while true
do
  show_menus
  read_options
done
