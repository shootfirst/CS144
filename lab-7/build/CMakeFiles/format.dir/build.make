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

# Utility rule file for format.

# Include the progress variables for this target.
include CMakeFiles/format.dir/progress.make

CMakeFiles/format:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/shootzecond/sponge/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Formatted all source files."
	clang-format-6.0 -i /home/shootzecond/sponge/apps/bidirectional_stream_copy.cc /home/shootzecond/sponge/apps/bouncer.cc /home/shootzecond/sponge/apps/lab7.cc /home/shootzecond/sponge/apps/network_simulator.cc /home/shootzecond/sponge/apps/tcp_benchmark.cc /home/shootzecond/sponge/apps/tcp_ip_ethernet.cc /home/shootzecond/sponge/apps/tcp_ipv4.cc /home/shootzecond/sponge/apps/tcp_native.cc /home/shootzecond/sponge/apps/tcp_udp.cc /home/shootzecond/sponge/apps/tun.cc /home/shootzecond/sponge/apps/udp_tcpdump.cc /home/shootzecond/sponge/apps/webget.cc /home/shootzecond/sponge/doctests/address_dt.cc /home/shootzecond/sponge/doctests/address_example_1.cc /home/shootzecond/sponge/doctests/address_example_2.cc /home/shootzecond/sponge/doctests/address_example_3.cc /home/shootzecond/sponge/doctests/parser_dt.cc /home/shootzecond/sponge/doctests/parser_example.cc /home/shootzecond/sponge/doctests/socket_dt.cc /home/shootzecond/sponge/doctests/socket_example_1.cc /home/shootzecond/sponge/doctests/socket_example_2.cc /home/shootzecond/sponge/doctests/socket_example_3.cc /home/shootzecond/sponge/libsponge/byte_stream.cc /home/shootzecond/sponge/libsponge/network_interface.cc /home/shootzecond/sponge/libsponge/router.cc /home/shootzecond/sponge/libsponge/stream_reassembler.cc /home/shootzecond/sponge/libsponge/tcp_connection.cc /home/shootzecond/sponge/libsponge/tcp_helpers/arp_message.cc /home/shootzecond/sponge/libsponge/tcp_helpers/ethernet_frame.cc /home/shootzecond/sponge/libsponge/tcp_helpers/ethernet_header.cc /home/shootzecond/sponge/libsponge/tcp_helpers/fd_adapter.cc /home/shootzecond/sponge/libsponge/tcp_helpers/ipv4_datagram.cc /home/shootzecond/sponge/libsponge/tcp_helpers/ipv4_header.cc /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_header.cc /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_over_ip.cc /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_segment.cc /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_sponge_socket.cc /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_state.cc /home/shootzecond/sponge/libsponge/tcp_helpers/tuntap_adapter.cc /home/shootzecond/sponge/libsponge/tcp_receiver.cc /home/shootzecond/sponge/libsponge/tcp_sender.cc /home/shootzecond/sponge/libsponge/util/address.cc /home/shootzecond/sponge/libsponge/util/buffer.cc /home/shootzecond/sponge/libsponge/util/eventloop.cc /home/shootzecond/sponge/libsponge/util/file_descriptor.cc /home/shootzecond/sponge/libsponge/util/parser.cc /home/shootzecond/sponge/libsponge/util/socket.cc /home/shootzecond/sponge/libsponge/util/tun.cc /home/shootzecond/sponge/libsponge/util/util.cc /home/shootzecond/sponge/libsponge/wrapping_integers.cc /home/shootzecond/sponge/tests/byte_stream_capacity.cc /home/shootzecond/sponge/tests/byte_stream_construction.cc /home/shootzecond/sponge/tests/byte_stream_many_writes.cc /home/shootzecond/sponge/tests/byte_stream_one_write.cc /home/shootzecond/sponge/tests/byte_stream_test_harness.cc /home/shootzecond/sponge/tests/byte_stream_two_writes.cc /home/shootzecond/sponge/tests/fsm_ack_rst.cc /home/shootzecond/sponge/tests/fsm_ack_rst_relaxed.cc /home/shootzecond/sponge/tests/fsm_ack_rst_win.cc /home/shootzecond/sponge/tests/fsm_ack_rst_win_relaxed.cc /home/shootzecond/sponge/tests/fsm_active_close.cc /home/shootzecond/sponge/tests/fsm_connect.cc /home/shootzecond/sponge/tests/fsm_connect_relaxed.cc /home/shootzecond/sponge/tests/fsm_listen.cc /home/shootzecond/sponge/tests/fsm_listen_relaxed.cc /home/shootzecond/sponge/tests/fsm_loopback.cc /home/shootzecond/sponge/tests/fsm_loopback_win.cc /home/shootzecond/sponge/tests/fsm_passive_close.cc /home/shootzecond/sponge/tests/fsm_reorder.cc /home/shootzecond/sponge/tests/fsm_retx.cc /home/shootzecond/sponge/tests/fsm_retx_relaxed.cc /home/shootzecond/sponge/tests/fsm_retx_win.cc /home/shootzecond/sponge/tests/fsm_stream_reassembler_cap.cc /home/shootzecond/sponge/tests/fsm_stream_reassembler_dup.cc /home/shootzecond/sponge/tests/fsm_stream_reassembler_holes.cc /home/shootzecond/sponge/tests/fsm_stream_reassembler_many.cc /home/shootzecond/sponge/tests/fsm_stream_reassembler_overlapping.cc /home/shootzecond/sponge/tests/fsm_stream_reassembler_seq.cc /home/shootzecond/sponge/tests/fsm_stream_reassembler_single.cc /home/shootzecond/sponge/tests/fsm_stream_reassembler_win.cc /home/shootzecond/sponge/tests/fsm_winsize.cc /home/shootzecond/sponge/tests/ipv4_parser.cc /home/shootzecond/sponge/tests/net_interface.cc /home/shootzecond/sponge/tests/network_interface_test_harness.cc /home/shootzecond/sponge/tests/recv_close.cc /home/shootzecond/sponge/tests/recv_connect.cc /home/shootzecond/sponge/tests/recv_reorder.cc /home/shootzecond/sponge/tests/recv_special.cc /home/shootzecond/sponge/tests/recv_transmit.cc /home/shootzecond/sponge/tests/recv_window.cc /home/shootzecond/sponge/tests/send_ack.cc /home/shootzecond/sponge/tests/send_close.cc /home/shootzecond/sponge/tests/send_connect.cc /home/shootzecond/sponge/tests/send_equivalence_checker.cc /home/shootzecond/sponge/tests/send_extra.cc /home/shootzecond/sponge/tests/send_retx.cc /home/shootzecond/sponge/tests/send_transmit.cc /home/shootzecond/sponge/tests/send_window.cc /home/shootzecond/sponge/tests/tcp_fsm_test_harness.cc /home/shootzecond/sponge/tests/tcp_parser.cc /home/shootzecond/sponge/tests/wrapping_integers_cmp.cc /home/shootzecond/sponge/tests/wrapping_integers_roundtrip.cc /home/shootzecond/sponge/tests/wrapping_integers_unwrap.cc /home/shootzecond/sponge/tests/wrapping_integers_wrap.cc /home/shootzecond/sponge/apps/bidirectional_stream_copy.hh /home/shootzecond/sponge/libsponge/byte_stream.hh /home/shootzecond/sponge/libsponge/network_interface.hh /home/shootzecond/sponge/libsponge/router.hh /home/shootzecond/sponge/libsponge/stream_reassembler.hh /home/shootzecond/sponge/libsponge/tcp_connection.hh /home/shootzecond/sponge/libsponge/tcp_helpers/arp_message.hh /home/shootzecond/sponge/libsponge/tcp_helpers/ethernet_frame.hh /home/shootzecond/sponge/libsponge/tcp_helpers/ethernet_header.hh /home/shootzecond/sponge/libsponge/tcp_helpers/fd_adapter.hh /home/shootzecond/sponge/libsponge/tcp_helpers/ipv4_datagram.hh /home/shootzecond/sponge/libsponge/tcp_helpers/ipv4_header.hh /home/shootzecond/sponge/libsponge/tcp_helpers/lossy_fd_adapter.hh /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_config.hh /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_header.hh /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_over_ip.hh /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_segment.hh /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_sponge_socket.hh /home/shootzecond/sponge/libsponge/tcp_helpers/tcp_state.hh /home/shootzecond/sponge/libsponge/tcp_helpers/tuntap_adapter.hh /home/shootzecond/sponge/libsponge/tcp_receiver.hh /home/shootzecond/sponge/libsponge/tcp_sender.hh /home/shootzecond/sponge/libsponge/util/address.hh /home/shootzecond/sponge/libsponge/util/buffer.hh /home/shootzecond/sponge/libsponge/util/eventloop.hh /home/shootzecond/sponge/libsponge/util/file_descriptor.hh /home/shootzecond/sponge/libsponge/util/parser.hh /home/shootzecond/sponge/libsponge/util/socket.hh /home/shootzecond/sponge/libsponge/util/tun.hh /home/shootzecond/sponge/libsponge/util/util.hh /home/shootzecond/sponge/libsponge/wrapping_integers.hh /home/shootzecond/sponge/tests/byte_stream_test_harness.hh /home/shootzecond/sponge/tests/fsm_retx.hh /home/shootzecond/sponge/tests/fsm_stream_reassembler_harness.hh /home/shootzecond/sponge/tests/network_interface_test_harness.hh /home/shootzecond/sponge/tests/receiver_harness.hh /home/shootzecond/sponge/tests/send_equivalence_checker.hh /home/shootzecond/sponge/tests/sender_harness.hh /home/shootzecond/sponge/tests/string_conversions.hh /home/shootzecond/sponge/tests/tcp_expectation.hh /home/shootzecond/sponge/tests/tcp_expectation_forward.hh /home/shootzecond/sponge/tests/tcp_fsm_test_harness.hh /home/shootzecond/sponge/tests/test_err_if.hh /home/shootzecond/sponge/tests/test_should_be.hh /home/shootzecond/sponge/tests/test_utils.hh /home/shootzecond/sponge/tests/test_utils_ipv4.hh

format: CMakeFiles/format
format: CMakeFiles/format.dir/build.make

.PHONY : format

# Rule to build all files generated by this target.
CMakeFiles/format.dir/build: format

.PHONY : CMakeFiles/format.dir/build

CMakeFiles/format.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/format.dir/cmake_clean.cmake
.PHONY : CMakeFiles/format.dir/clean

CMakeFiles/format.dir/depend:
	cd /home/shootzecond/sponge/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/shootzecond/sponge /home/shootzecond/sponge /home/shootzecond/sponge/build /home/shootzecond/sponge/build /home/shootzecond/sponge/build/CMakeFiles/format.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/format.dir/depend
