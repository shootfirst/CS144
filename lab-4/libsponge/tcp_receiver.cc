#include "tcp_receiver.hh"

// Dummy implementation of a TCP receiver

// For Lab 2, please replace with a real implementation that passes the
// automated checks run by `make check_lab2`.

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

void TCPReceiver::segment_received(const TCPSegment &seg) {
    TCPHeader rec_header = seg.header();
    //若第一次收到syn报文段,可能会多次收到syn
    if (rec_header.syn && !is_set) {
        is_set = true;
        isn = rec_header.seqno;
    }
    //若停止写入，则丢弃
    if (stream_out().input_ended()) {
        return;
    }
    //若还未收到syn报文段，则丢弃
    if (!is_set) {
        // todo
        return;
    }

    WrappingInt32 seqno = rec_header.seqno;
    uint64_t abs_seqno = unwrap(seqno, isn, hope_to_rec + 1);
    _reassembler.push_substring(seg.payload().copy(), abs_seqno - 1 + rec_header.syn, seg.header().fin);
    hope_to_rec = _reassembler.get_hope_to_rec();
}

optional<WrappingInt32> TCPReceiver::ackno() const {
    if (is_set && !stream_out().input_ended()) {
        return {wrap(hope_to_rec + 1, isn)};
    } else if (stream_out().input_ended()) {
        return {wrap(hope_to_rec + 2, isn)};
    } else {
        return {};
    }
}

size_t TCPReceiver::window_size() const { return stream_out().remaining_capacity(); }
