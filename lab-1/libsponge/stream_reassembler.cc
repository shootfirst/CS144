#include "stream_reassembler.hh"

// Dummy implementation of a stream reassembler.

// For Lab 1, please replace with a real implementation that passes the
// automated checks run by `make check_lab1`.

// You will need to add private members to the class declaration in `stream_reassembler.hh`

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

StreamReassembler::StreamReassembler(const size_t capacity) : _output(capacity), _capacity(capacity) {}

void StreamReassembler::push_substring(const string &data, const size_t index, const bool eof) {
    /**
     * 
     * 
     * start：data子串的开始index，len：子串长度
     * 流程：
     * 1.对传入的data，在map中找上界up
     *      a.找到，判断是否交叉，交叉则判断是否被包围，包围则结束，否则修改start为up->first+up->second.size()-index;
     *      b.没有找到，判断index是否<=hope_to_rec,是则进行相应剪切和丢弃；
     * 2.在map中找下界down
     *      a.找到，判断是否交叉，交叉则判断是否包围，包围则删除down，继续2，否则修改len为down->first-start;否则直接插入，结束；
     *      b.没有找到，判断start是否越界，越界则丢弃，结束，否则插入map，结束；
     * 3.进行判断是否能写入_output，能则写入，判断是否全部写入，没有则将剩余插入map
     * 4.若成功写入且缓冲区未溢出，则在map中拿出第一个尝试写入，能则重复
     * 5.求eof_idx，若满足eof_idx<=hope_to_rec则结束写入
     * 
     * 
    */
//    if (data.size() == 0) {
//        return;
//    }

   size_t start = index;
   auto up = unassembled_slice.upper_bound(start);
   if (up != unassembled_slice.begin()) {
       up --;
   }


   if (up != unassembled_slice.end() && up -> first <= start) {
       if (up -> first + (up -> second).size() > start) {
           start = up -> first + (up -> second).size();
           if (start >= index + data.size()) {
               return;
           }
       }
   }
   else {
       if (hope_to_rec > start) {
           start = hope_to_rec;
           if (start >= index + data.size()) {
               return;
           }
       }
   }


   size_t len = data.size() + index - start;
   auto down = unassembled_slice.lower_bound(start);

   while (down != unassembled_slice.end()) {
       if (down -> first < start + len) {
           if (down -> first + (down -> second).size() <= start + len) {
               unassembled_byte_num -= (down -> second).size();
               down = unassembled_slice.erase(down);
               continue;
           } 
           else {
               len = down -> first - start;
               break;
           }
       }
       else {
           break;
       }
   }

   if (start >= hope_to_rec + _capacity - _output.buffer_size()) {
       return;
   }

   if (start == hope_to_rec) {
       size_t have_written = _output.write(data.substr(start - index, len));
       hope_to_rec += have_written;
       if (have_written < len) {
           unassembled_slice.insert(make_pair(start + have_written, data.substr(start + have_written - index, len - have_written)));
       }
   }else {
       unassembled_slice.insert(make_pair(start, data.substr(start - index, len)));
       unassembled_byte_num += len;
   }
   
   for (auto ptr = unassembled_slice.begin(); ptr != unassembled_slice.end();) {
       if (ptr -> first == hope_to_rec) {
            size_t have_written = _output.write(ptr -> second);
            hope_to_rec += have_written;
            unassembled_byte_num -= have_written;
            if (have_written < (ptr -> second).size()) {
                unassembled_slice.insert(make_pair(ptr -> first + have_written, data.substr(have_written, (ptr -> second).size() - have_written)));
                unassembled_slice.erase(ptr);
                break;
            }else {
                ptr = unassembled_slice.erase(ptr);
            }
       }else {
           break;
       }
   }
   
   if (eof) {
       eof_idx = start + len;
       is_eof = eof;
   }
   if (is_eof && eof_idx <= hope_to_rec) {
       _output.end_input();
   }
}

size_t StreamReassembler::unassembled_bytes() const { return unassembled_byte_num; }

bool StreamReassembler::empty() const { return unassembled_byte_num == 0; }


