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
include tests/CMakeFiles/wrapping_integers_cmp.dir/depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/wrapping_integers_cmp.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/wrapping_integers_cmp.dir/flags.make

tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o: tests/CMakeFiles/wrapping_integers_cmp.dir/flags.make
tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o: ../tests/wrapping_integers_cmp.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/shootzecond/sponge/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o"
	cd /home/shootzecond/sponge/build/tests && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o -c /home/shootzecond/sponge/tests/wrapping_integers_cmp.cc

tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.i"
	cd /home/shootzecond/sponge/build/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/shootzecond/sponge/tests/wrapping_integers_cmp.cc > CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.i

tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.s"
	cd /home/shootzecond/sponge/build/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/shootzecond/sponge/tests/wrapping_integers_cmp.cc -o CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.s

tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o.requires:

.PHONY : tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o.requires

tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o.provides: tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o.requires
	$(MAKE) -f tests/CMakeFiles/wrapping_integers_cmp.dir/build.make tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o.provides.build
.PHONY : tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o.provides

tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o.provides.build: tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o


# Object files for target wrapping_integers_cmp
wrapping_integers_cmp_OBJECTS = \
"CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o"

# External object files for target wrapping_integers_cmp
wrapping_integers_cmp_EXTERNAL_OBJECTS =

tests/wrapping_integers_cmp: tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o
tests/wrapping_integers_cmp: tests/CMakeFiles/wrapping_integers_cmp.dir/build.make
tests/wrapping_integers_cmp: tests/libspongechecks.a
tests/wrapping_integers_cmp: libsponge/libsponge.a
tests/wrapping_integers_cmp: tests/CMakeFiles/wrapping_integers_cmp.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/shootzecond/sponge/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable wrapping_integers_cmp"
	cd /home/shootzecond/sponge/build/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/wrapping_integers_cmp.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/wrapping_integers_cmp.dir/build: tests/wrapping_integers_cmp

.PHONY : tests/CMakeFiles/wrapping_integers_cmp.dir/build

tests/CMakeFiles/wrapping_integers_cmp.dir/requires: tests/CMakeFiles/wrapping_integers_cmp.dir/wrapping_integers_cmp.cc.o.requires

.PHONY : tests/CMakeFiles/wrapping_integers_cmp.dir/requires

tests/CMakeFiles/wrapping_integers_cmp.dir/clean:
	cd /home/shootzecond/sponge/build/tests && $(CMAKE_COMMAND) -P CMakeFiles/wrapping_integers_cmp.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/wrapping_integers_cmp.dir/clean

tests/CMakeFiles/wrapping_integers_cmp.dir/depend:
	cd /home/shootzecond/sponge/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/shootzecond/sponge /home/shootzecond/sponge/tests /home/shootzecond/sponge/build /home/shootzecond/sponge/build/tests /home/shootzecond/sponge/build/tests/CMakeFiles/wrapping_integers_cmp.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/wrapping_integers_cmp.dir/depend

