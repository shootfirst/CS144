#include "network_interface.hh"

#include "arp_message.hh"
#include "ethernet_frame.hh"

#include <iostream>

// Dummy implementation of a network interface
// Translates from {IP datagram, next hop address} to link-layer frame, and from link-layer frame to IP datagram

// For Lab 5, please replace with a real implementation that passes the
// automated checks run by `make check_lab5`.

// You will need to add private members to the class declaration in `network_interface.hh`

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

//! \param[in] ethernet_address Ethernet (what ARP calls "hardware") address of the interface
//! \param[in] ip_address IP (what ARP calls "protocol") address of the interface
NetworkInterface::NetworkInterface(const EthernetAddress &ethernet_address, const Address &ip_address)
    : _ethernet_address(ethernet_address), _ip_address(ip_address) {
    cerr << "DEBUG: Network interface has Ethernet address " << to_string(_ethernet_address) << " and IP address "
         << ip_address.ip() << "\n";
}

//! \param[in] dgram the IPv4 datagram to be sent
//! \param[in] next_hop the IP address of the interface to send it to (typically a router or default gateway, but may also be another host if directly connected to the same network as the destination)
//! (Note: the Address type can be converted to a uint32_t (raw 32-bit IP address) with the Address::ipv4_numeric() method.)
void NetworkInterface::send_datagram(const InternetDatagram &dgram, const Address &next_hop) {
    // convert IP address of next hop to raw 32-bit representation (used in ARP header)
    const uint32_t next_hop_ip = next_hop.ipv4_numeric();

    auto it = _arp_map.find(next_hop_ip);
    if (it != _arp_map.end()) {
        
        EthernetHeader eth_head;
        eth_head.dst = (it -> second).first;
        eth_head.src = _ethernet_address;
        eth_head.type = EthernetHeader::TYPE_IPv4;

        EthernetFrame send_frame;
        send_frame.header() = eth_head;
        send_frame.payload() = dgram.serialize();
        _frames_out.push(send_frame);

    }
    else {
        if (_send_msg.find(next_hop_ip) == _send_msg.end()) {
            broadcast(next_hop_ip);
            _send_msg.insert(std::make_pair(next_hop_ip, _time));
        }
        _dgram_cache.push_back(std::make_pair(next_hop, dgram));
    }
    
}

//! \param[in] frame the incoming Ethernet frame
optional<InternetDatagram> NetworkInterface::recv_frame(const EthernetFrame &frame) {
    //首先查看是否是广播地址或者目的地是本接口
    if (frame.header().dst != ETHERNET_BROADCAST && frame.header().dst != _ethernet_address) {
        return {};
    }

    if (frame.header().type == frame.header().TYPE_IPv4) {
        InternetDatagram seg;
        if (seg.parse(frame.payload()) == ParseResult::NoError) {
            return seg;
        }
        else {
            cerr << "cerr: parse ipv4 in error\n";
            return {};
        }
    }

    else if (frame.header().type == frame.header().TYPE_ARP) {
        ARPMessage seg;
        //解析成功
        if (seg.parse(frame.payload()) == ParseResult::NoError) {
            //记住发送方的IP地址和以太网地址之间的映射，持续30秒。
            _arp_map.insert(std::make_pair(seg.sender_ip_address, std::make_pair(seg.sender_ethernet_address, _time)));


            if (seg.opcode == ARPMessage::OPCODE_REPLY) {
                for (auto it = _dgram_cache.begin(); it != _dgram_cache.end(); ) {
                    if (it -> first.ipv4_numeric() == seg.sender_ip_address) {
                        EthernetHeader eth_head;
                        eth_head.dst = seg.sender_ethernet_address;
                        eth_head.src = _ethernet_address ;
                        eth_head.type = frame.header().TYPE_IPv4;

                        EthernetFrame send_frame;
                        send_frame.header() = eth_head;
                        send_frame.payload() = it -> second.serialize();
                        _frames_out.push(send_frame);
                        it = _dgram_cache.erase(it);

                        _send_msg.erase(seg.sender_ip_address);
                    }
                    else {
                        it ++;
                    }
                }
            }

            //假如是请求包并且请求的是我们的ip地址，发送回复包告诉我们的mac地址
            if (seg.opcode == ARPMessage::OPCODE_REQUEST && seg.target_ip_address == _ip_address.ipv4_numeric()) {
                ARPMessage arp_reply;
                //arp填写相关字段
                arp_reply.hardware_type = ARPMessage::TYPE_ETHERNET;
                arp_reply.protocol_type = EthernetHeader::TYPE_IPv4;
                arp_reply.hardware_address_size = sizeof(EthernetHeader::src);
                arp_reply.protocol_address_size = sizeof(IPv4Header::src);
                arp_reply.opcode = ARPMessage::OPCODE_REPLY;
                arp_reply.sender_ethernet_address = _ethernet_address;
                arp_reply.sender_ip_address = _ip_address.ipv4_numeric();
                arp_reply.target_ethernet_address = seg.sender_ethernet_address;
                arp_reply.target_ip_address = seg.sender_ip_address;


                //填写ethernet相关字段
                EthernetHeader eth_head;
                eth_head.dst = seg.sender_ethernet_address;
                eth_head.src = _ethernet_address;
                eth_head.type = frame.header().TYPE_ARP;

                //发送
                EthernetFrame send_frame;
                send_frame.header() = eth_head;
                send_frame.payload() = arp_reply.serialize();
                _frames_out.push(send_frame);
                
            }

        }
        else {
            cerr << "cerr: parse arp in error\n";
            return {};
        }
    }

    else {
        cerr << "cerr: do not have this protocol\n";
        return {};
    }

    return {};
    
}

//! \param[in] ms_since_last_tick the number of milliseconds since the last call to this method
void NetworkInterface::tick(const size_t ms_since_last_tick) { 
    _time += ms_since_last_tick;

    auto it = _arp_map.begin();
    while (it != _arp_map.end()) {
        //超过30s，删除
        if ((it -> second).second + 30 * 1000 < _time) {
            it = _arp_map.erase(it);
        }
        else {
            it ++;
        }
    }

    
    for (auto itr = _send_msg.begin(); itr != _send_msg.end(); itr ++) {
        if (itr -> second + 5 * 1000 < _time) {
            broadcast(itr -> first);
            itr -> second = _time;
        }
    }
}

void NetworkInterface::broadcast(uint32_t ip) {
    ARPMessage arp_reply;
    //arp填写相关字段
    arp_reply.hardware_type = ARPMessage::TYPE_ETHERNET;
    arp_reply.protocol_type = EthernetHeader::TYPE_IPv4;
    arp_reply.hardware_address_size = sizeof(EthernetHeader::src);
    arp_reply.protocol_address_size = sizeof(IPv4Header::src);
    arp_reply.opcode = ARPMessage::OPCODE_REQUEST;
    arp_reply.sender_ethernet_address = _ethernet_address;
    arp_reply.sender_ip_address = _ip_address.ipv4_numeric();
    arp_reply.target_ethernet_address = {};
    arp_reply.target_ip_address = ip;


    //填写ethernet相关字段
    EthernetHeader eth_head;
    eth_head.dst = ETHERNET_BROADCAST;
    eth_head.src = _ethernet_address;
    eth_head.type = EthernetHeader::TYPE_ARP;

    //发送
    EthernetFrame send_frame;
    send_frame.header() = eth_head;
    send_frame.payload() = arp_reply.serialize();
    _frames_out.push(send_frame);
}
