#!/bin/bash

#
# THIS IS NOT TESTED!
#
# This script clone the llvm and builds (see CONFIG_CMAKE_OPTS)
# The directory structure is going to be
# $CONFIG_WORKING_DIR/llvm-project -- contain llvm source code
# $CONFIG_WORKING_DIR/llvm-build   -- contain debug build for llvm
# All variable starting with CONFIG_ can be used to configure the build
#

# --- Beginning of this script config variables ---

# Reset this to desired workspcace
CONFIG_WORKING_DIR=${HOME}/llvm

# Build directory for llvm
CONFIG_BUILD_DIR=${CONFIG_WORKING_DIR}/llvm-build

# CPU count
CONFIG_CPU_COUNT=6
 
# --- Beginning of llvm CMake config ---
#
# DLLVM_USE_LINKER=gold: Use gold linker; it uses less memory
# DLLVM_USE_SPLIT_DWARF=ON: Use split drwarf; It results in a smaller build size
# DLLVM_ENABLE_PROJECTS=clang: Enable clang build
# DLLVM_TARGETS_TO_BUILD=X86: We only care about x86 traget; this reduces biuld time
#
declare -a CONFIG_CMAKE_OPTS=(
	"-DLLVM_USE_LINKER=gold"
    "-DLLVM_USE_SPLIT_DWARF=ON"
	"-DLLVM_ENABLE_PROJECTS=clang"
    "-DLLVM_TARGETS_TO_BUILD=X86"
)
# --- Beginning of llvm CMake config ---

# --- End of this script config variables ---

# Create a working directory if it don't exist
if [ ! -d $CONFIG_WORKING_DIR ]; then
  mkdir $CONFIG_WORKING_DIR
fi

# Move to workspace
cd ${CONFIG_WORKING_DIR}

# Clone llvm
git clone https://github.com/llvm/llvm-project.git

if [ ! -d ${CONFIG_BUILD_DIR} ]; then
  # This is going to be the build directory
  mkdir ${CONFIG_BUILD_DIR}
else
  # Clean the current build directory
  cd ${CONFIG_BUILD_DIR}
  rm -rf *
fi

# Now we are inside the clean build directory

CMAKE_OPTS=""
for opt in "${CONFIG_CMAKE_OPTS[@]}"
do
  CMAKE_OPTS+="$opt"
done

# Build the Makefiles
cmake ${CMAKE_OPTS} -j${CONFIG_CPU_COUNT} -G "Unix Makefiles" ${CONFIG_WORKING_DIR}/llvm-project/llvm

# Start the build
make -j${CONFIG_CPU_COUNT}

# EOF
