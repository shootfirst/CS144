#include "byte_stream.hh"

#include <algorithm>
#include <iterator>
#include <stdexcept>

// Dummy implementation of a flow-controlled in-memory byte stream.

// For Lab 0, please replace with a real implementation that passes the
// automated checks run by `make check_lab0`.

// You will need to add private members to the class declaration in `byte_stream.hh`

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

ByteStream::ByteStream(const size_t capacity) : size(capacity) {}

size_t ByteStream::write(const string &data) {
    size_t rem = size - buffer.size();
    size_t push_num = min(rem, data.size());
    size_t i;
    for (i = 0; i < push_num; i++) {
        buffer.push_back(data[i]);

        have_written++;
    }
    return i;
}

//! \param[in] len bytes will be copied from the output side of the buffer
string ByteStream::peek_output(const size_t len) const {
    string res;
    size_t peek_size = min(len, buffer.size());
    size_t i = 0;
    for (auto it = buffer.begin(); (it != buffer.end()) && (i < peek_size); i++, it++) {
        res.push_back(*it);
    }
    return res;
}

//! \param[in] len bytes will be removed from the output side of the buffer
void ByteStream::pop_output(const size_t len) {
    size_t pop_size = min(len, buffer.size());
    for (size_t i = 0; i < pop_size; i++) {
        buffer.pop_front();
        have_read++;
    }
}

//! Read (i.e., copy and then pop) the next "len" bytes of the stream
//! \param[in] len bytes will be popped and returned
//! \returns a string
std::string ByteStream::read(const size_t len) {
    string res;
    res = peek_output(len);
    pop_output(len);
    // have_read += res.size();
    return res;
}

void ByteStream::end_input() { is_end = true; }

bool ByteStream::input_ended() const { return is_end; }

size_t ByteStream::buffer_size() const { return buffer.size(); }

bool ByteStream::buffer_empty() const { return buffer.size() == 0; }

bool ByteStream::eof() const { return is_end && buffer_empty(); }

size_t ByteStream::bytes_written() const { return have_written; }

size_t ByteStream::bytes_read() const { return have_read; }

size_t ByteStream::remaining_capacity() const { return size - buffer.size(); }
