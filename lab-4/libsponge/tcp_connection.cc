#include "tcp_connection.hh"

#include <iostream>

// Dummy implementation of a TCP connection

// For Lab 4, please replace with a real implementation that passes the
// automated checks run by `make check`.

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

size_t TCPConnection::remaining_outbound_capacity() const { return _sender.stream_in().remaining_capacity(); }

size_t TCPConnection::bytes_in_flight() const { return _sender.bytes_in_flight(); }

size_t TCPConnection::unassembled_bytes() const { return _receiver.unassembled_bytes(); }

size_t TCPConnection::time_since_last_segment_received() const { return _time_since_last_segment_received; }

bool TCPConnection::active() const { return is_active; }


//四个关键状态，其余状态可看成简单的发送和recieve
void TCPConnection::segment_received(const TCPSegment &seg) { 
    _time_since_last_segment_received = 0;

    //是否进入error状态
    if (seg.header().rst) {
        set_rst(false);
        return;
    }

    _receiver.segment_received(seg);


    bool if_send_empty_seg = seg.length_in_sequence_space();

    if (seg.header().ack) {
        //注意，调用ack_recieved方法后会调用fill_window发送报文
        _sender.ack_received(seg.header().ackno, seg.header().win);
        if (if_send_empty_seg && !_sender.segments_out().empty()) {
            if_send_empty_seg = false;
        }
    }

    //是否进入syn_rcvd状态,注意此时判断sender状态不是是否为SYN_SENT，因为此时syn还未发送
    if (TCPState::state_summary(_receiver) == TCPReceiverStateSummary::SYN_RECV &&
        TCPState::state_summary(_sender) == TCPSenderStateSummary::CLOSED) {
        connect();
        return;
    }

    //是否进入close_wait状态
    if (TCPState::state_summary(_receiver) == TCPReceiverStateSummary::FIN_RECV &&
       TCPState::state_summary(_sender) == TCPSenderStateSummary::SYN_ACKED) {
        _linger_after_streams_finish = false;
    }
    
    //判断此时是否需要发送空报文
    if (if_send_empty_seg) {
        _sender.send_empty_segment();
    }
    add_ack_and_winsize();


    //是否进入closs状态，即此时收到对面fin，自己已经收到finack，_linger_after_streams_finish为false，并且此时又收到seg
    //（调用此函数segment_received就代表收到seg)
    if (TCPState::state_summary(_receiver) == TCPReceiverStateSummary::FIN_RECV &&
        TCPState::state_summary(_sender) == TCPSenderStateSummary::FIN_ACKED && 
        _linger_after_streams_finish == false) {
        is_active = false;
    }
}

//! \param[in] ms_since_last_tick number of milliseconds since the last call to this method
void TCPConnection::tick(const size_t ms_since_last_tick) { 
    _time_since_last_segment_received += ms_since_last_tick;
    _sender.tick(ms_since_last_tick);
    //注意，必须先判断重传次数是否大于8，再进行发送，否则将会出现发送9次的情况
    if (_sender.consecutive_retransmissions() > _cfg.MAX_RETX_ATTEMPTS) {
        while (!_sender.segments_out().empty()) {
            _sender.segments_out().pop();
        }
        set_rst(true);
        return;
    }
    add_ack_and_winsize();

    // 如果到达TIME_WAIT状态,并且已经过了10倍的初始重传超时(_cfg.rt_timeout)
    if (TCPState::state_summary(_receiver) == TCPReceiverStateSummary::FIN_RECV &&
        TCPState::state_summary(_sender) == TCPSenderStateSummary::FIN_ACKED &&
        _linger_after_streams_finish && _time_since_last_segment_received >= 10 * _cfg.rt_timeout) {
        _linger_after_streams_finish = false;
        is_active = false;
    }
    
}

size_t TCPConnection::write(const string &data) {
    size_t written_len = _sender.stream_in().write(data);
    //写完后可能此时窗口大小足够，但是由于streamin写之前是空的导致可以发送数据但无数据可发送，此时需要手动调用fill_window
    _sender.fill_window();
    //此方法一般和fillwindow成对出现
    add_ack_and_winsize();
    return written_len;
}

//此方法相当于特殊的written，写入一个fin
void TCPConnection::end_input_stream() { 
    _sender.stream_in().end_input();
    //此时窗口可能存在空闲位置，可以发送fin
    _sender.fill_window();
    add_ack_and_winsize();
}

//此方法相当于特殊的written，写入一个syn
void TCPConnection::connect() {
    //此时是第一次调用fillwindow，发送syn报文，不携带任何数据
    _sender.fill_window();
    add_ack_and_winsize();
}

void TCPConnection::add_ack_and_winsize() {
    while (!_sender.segments_out().empty()) {
        TCPSegment seg = _sender.segments_out().front();
        _sender.segments_out().pop();
        if (_receiver.ackno().has_value()) {
            seg.header().ack = true;
            seg.header().ackno = _receiver.ackno().value();
            seg.header().win = _receiver.window_size();
        }
        _segments_out.push(seg);
    }
    
}

//! \param[in] if_send if we send a rst segment
void TCPConnection::set_rst(bool if_send) {
    _sender.stream_in().set_error();
    _receiver.stream_out().set_error();
    is_active = false;
    _linger_after_streams_finish = false;
    if (if_send) {
        TCPSegment seg;
        seg.header().rst = true;
        seg.header().seqno = _sender.next_seqno();
        _segments_out.push(seg);
    }
}




TCPConnection::~TCPConnection() {
    try {
        if (active()) {
            cerr << "Warning: Unclean shutdown of TCPConnection\n";

            // Your code here: need to send a RST segment to the peer
            set_rst(true);
        }
    } catch (const exception &e) {
        std::cerr << "Exception destructing TCP FSM: " << e.what() << std::endl;
    }
}





