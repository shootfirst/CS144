# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/shootzecond/sponge

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/shootzecond/sponge/build

# Include any dependencies generated for this target.
include apps/CMakeFiles/lab7.dir/depend.make

# Include the progress variables for this target.
include apps/CMakeFiles/lab7.dir/progress.make

# Include the compile flags for this target's objects.
include apps/CMakeFiles/lab7.dir/flags.make

apps/CMakeFiles/lab7.dir/lab7.cc.o: apps/CMakeFiles/lab7.dir/flags.make
apps/CMakeFiles/lab7.dir/lab7.cc.o: ../apps/lab7.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/shootzecond/sponge/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object apps/CMakeFiles/lab7.dir/lab7.cc.o"
	cd /home/shootzecond/sponge/build/apps && /usr/bin/g++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/lab7.dir/lab7.cc.o -c /home/shootzecond/sponge/apps/lab7.cc

apps/CMakeFiles/lab7.dir/lab7.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/lab7.dir/lab7.cc.i"
	cd /home/shootzecond/sponge/build/apps && /usr/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/shootzecond/sponge/apps/lab7.cc > CMakeFiles/lab7.dir/lab7.cc.i

apps/CMakeFiles/lab7.dir/lab7.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/lab7.dir/lab7.cc.s"
	cd /home/shootzecond/sponge/build/apps && /usr/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/shootzecond/sponge/apps/lab7.cc -o CMakeFiles/lab7.dir/lab7.cc.s

apps/CMakeFiles/lab7.dir/lab7.cc.o.requires:

.PHONY : apps/CMakeFiles/lab7.dir/lab7.cc.o.requires

apps/CMakeFiles/lab7.dir/lab7.cc.o.provides: apps/CMakeFiles/lab7.dir/lab7.cc.o.requires
	$(MAKE) -f apps/CMakeFiles/lab7.dir/build.make apps/CMakeFiles/lab7.dir/lab7.cc.o.provides.build
.PHONY : apps/CMakeFiles/lab7.dir/lab7.cc.o.provides

apps/CMakeFiles/lab7.dir/lab7.cc.o.provides.build: apps/CMakeFiles/lab7.dir/lab7.cc.o


# Object files for target lab7
lab7_OBJECTS = \
"CMakeFiles/lab7.dir/lab7.cc.o"

# External object files for target lab7
lab7_EXTERNAL_OBJECTS =

apps/lab7: apps/CMakeFiles/lab7.dir/lab7.cc.o
apps/lab7: apps/CMakeFiles/lab7.dir/build.make
apps/lab7: apps/libstream_copy.a
apps/lab7: libsponge/libsponge.a
apps/lab7: /usr/lib/x86_64-linux-gnu/libpthread.so
apps/lab7: apps/CMakeFiles/lab7.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/shootzecond/sponge/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable lab7"
	cd /home/shootzecond/sponge/build/apps && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/lab7.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
apps/CMakeFiles/lab7.dir/build: apps/lab7

.PHONY : apps/CMakeFiles/lab7.dir/build

apps/CMakeFiles/lab7.dir/requires: apps/CMakeFiles/lab7.dir/lab7.cc.o.requires

.PHONY : apps/CMakeFiles/lab7.dir/requires

apps/CMakeFiles/lab7.dir/clean:
	cd /home/shootzecond/sponge/build/apps && $(CMAKE_COMMAND) -P CMakeFiles/lab7.dir/cmake_clean.cmake
.PHONY : apps/CMakeFiles/lab7.dir/clean

apps/CMakeFiles/lab7.dir/depend:
	cd /home/shootzecond/sponge/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/shootzecond/sponge /home/shootzecond/sponge/apps /home/shootzecond/sponge/build /home/shootzecond/sponge/build/apps /home/shootzecond/sponge/build/apps/CMakeFiles/lab7.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : apps/CMakeFiles/lab7.dir/depend

