# CS144 斯坦福2021秋季计算机网络实验
cs144官网：https://kangyupl.gitee.io/cs144.github.io/
非常感谢这两位博主，太强了，带我飞：http://doraemonzzz.com/tags/CS144/    https://kiprey.github.io/tags/CS144/

## lab0

实验零有两小部分。分别是实现和手动获取网页相同功能的函数和实现内存字节流读取可靠服务

+ 手动获取网页

补充get_URL函数，代码量10几行

此部分关键点一我觉得是通过套接字和采用http协议的服务器沟通时，每行命令结束应该以\r\n结束，最后键入所有命令后同样要写入\r\n，如

GET /hello HTTP/1.1
Host: http://cs144.Keithw.org
Connection: close
你在写程序时应该这样"GET " + path + " " + "HTTP/1.1\r\nHost: " + host + "\r\nConnection: close\r\n\r\n"。

其次是调用shutdown函数时注意传入的参数，第一次我传入SHUT_RDWT,导致报错：read: Connection reset by peer

+ 内存可靠字节流

实现byte_stream.hh里面的ByteStream类相关函数，为方便代码编写可加入相关字段。关键在于缓冲区数据结构选取，我选的是list。

坑点：我开始实现时是read完结束时，给have_read变量一次性加上读取长度，可是测试不给我通过，我后来改成每pop一个have_read加1，给通过了。奇怪。



## lab1

实验一是实现一字节流重组器，将失序的字节流小块按顺序组装。
### 关键点

+ 重叠

字节流小块是有重叠的，甚至会包含，开始我以为像教材上一样，只会失序，而不会重叠（怪自己没好好看指导书），这是最关键的地方，也是最难解决的地方，解决好重叠这个关键点，实验思路基本理清

+ 数据结构

第二个是数据结构的选取，我开始选择的是链表，使用插入排序使得index有序，可是后来发现使用map可以使查找时间复杂度降到logn（对cpp不熟悉），果断使用map

### 编码思路

我没有添加辅助方法，所有处理都是实现在push_substring中，特别强大（甚至为实验三省写不少代码）。思路如下：首先对加入的data字符串进行切割，在map中找出和data重叠部分，进行切割，用start和len存储，最后调用sunstr。之后看是否能够写入_output能则写入，之后在map中弹出最小index直至不能加入，最后是后处理。具体步骤如下：
+ start：data子串的开始index
+ len：子串长度

+ 流程：
    + 对传入的data，在map中找上界up
      + 找到，判断是否交叉，交叉则判断是否被包围，包围则结束，否则修改start为up->first+up->second.size()-index;
      + 没有找到，判断index是否<=hope_to_rec,是则进行相应剪切和丢弃；
      
    + 在map中找下届down
      + 找到，判断是否交叉，交叉则判断是否包围，包围则删除down，继续2，否则修改len为down->first-start;否则直接插入，结束；
      + 没有找到，判断start是否越界，越界则丢弃，结束，否则插入map，结束；
      
    + 进行判断是否能写入_output，能则写入，判断是否全部写入，没有则将剩余插入map
    
    + 若成功写入且缓冲区未溢出，则在map中拿出第一个尝试写入，能则重复
  
    + 求eof_idx，若满足eof_idx<=hope_to_rec则结束写入



## lab2

实验二实现一个 TCPReceiver，用以接收传入的 TCP segment 并将其转换成用户可读的数据流。分为两个部分，索引转换和TCPReceiver 实现。

+ 索引转换

在TCP中，每个字节在数据流中的索引用一个32位的“序列号”（seqno）表示，这就增加了一些复杂性：

    + 开始和结束都算作序列中的一个位置：除了确保收到所有字节的数据外，TCP必须确保也能收到流的开始和结束。因此，在TCP中，SYN（数据流的开始）和FIN（数据流的结束）标志都被分配了序列号
    
    + 32位封装的序列号：在我们的StreamReassembler中，索引总是从0开始，并且有64位，在TCP中，传输的序列号是32位，如果数据流足够长的话，序列号就会循环
    
    + TCP序列号不从零开始：为了提高安全性和避免不同连接之间的混淆，TCP试图确保序列号不能被猜到，而且不太可能重复。因此，一个流的序列号不从零开始。流中的第一个序列号通常是一个随机的32位数字，称为初始序列号（ISN）
    
实现两个函数，wrap（绝对序列号转序列号）和unwrap（序列号转绝对序列号），unwrap注意余数相关性质，写得好45行代码解决。

+ TCPReceiver

实现三个方法：

    + segment received
        
        主要方法：对于 TCPReceiver 来说，除了错误状态以外，它一共有3种状态，分别是：

            + LISTEN：等待 SYN 包的到来。若在 SYN 包到来前就有其他数据到来，则必须丢弃
            + SYN_RECV：获取到了 SYN 包，此时可以正常的接收数据包
            + FIN_RECV：input_end，此时务必终止 ByteStream 数据流的输入
            
        状态设置：
            
            + 当 isn 还没设置时，肯定是 LISTEN 状态
            + 当 ByteStream.input_ended()，则肯定是 FIN_RECV 状态
            + 其他情况下，是 SYN_RECV 状态
        
        ackno 的计算必须考虑到 SYN 和 FIN 标志，因为这两个标志各占一个 seqno。故在返回 ackno 时，务必判断当前 接收者处于什么状态，然后依据当前状态来判断是否需要对当前的计算结果加1或加2。而这条准则对 push_substring 时同样适用。
        
        

    + ackno
    
        返回一个可选的<WrappingInt32>，包含接收方尚未知道的第一个字节的序列号。这就是窗口的左边缘：接收方感兴趣的第一个字节。如果ISN还没有被设置，返回一个空的可选值
        
    + window size
        
        求窗口大小
        
   
   
## lab3
实验三实现了tcp发送方。以下是tcp_sender的主要功能：
    
    + 每当可发送窗口大小变大，tcp_sender将尽可能多的ByteStream中的报文以tcp报文形式发送出去
    
    + 当接收到ack报文时，更新窗口大小，通过已确认序列号将已发送但未确认tcp报文队列中已确认报文删除
    
    + 当定时器过期时，重传已确认序列号将已发送但未确认tcp报文队列中中最早发出的tcp报文段，重启定时器
    
实验主要是实现三个方法（源实验指导书说的是四个，但我绝对第四个比较简单），分别是fill_window，ack_received，tick，以下是对三个方法功能的概述以及实现与坑点
    + fill_window
    
        - 功能：TCPSender 从 ByteStream 中读取数据，并以 TCPSegement 的形式发送，尽可能地填充接收者的窗口。但每个TCP段的大小不得超过 TCPConfig::MAX PAYLOAD SIZE
        
        - 实现：首先注意TCPSender需要发送SYN报文，并且根据tcp协议，是不能携带数据段的，即payload为空，其次是syn（fin同理）不占payload空间，但是占发送窗口空间（坑点），所以发送SYN           报文时，一定注意_next_seqno要记得+1。之后便是一个循环，当发送出去但未确认的报文长度大于等于窗口大小即退出循环，循环体中，从ByteStream读取数据段组成tcp报文发送，注意fin设           置时机，当之前没有设置fin并且ByteStream已经结束输出，还有一个坑点（上面提到）就是win窗口需要有一个空间来发送fin，否则需要将fin留到下一次单独发送。还需注意，发送前需要检查           未确认队列，为空则需要重启定时器。最后是避免两个死循环坑点：
            + 第一是数据报length_in_sequence_space为0
                - 发生这种情况，只能说明ByteStream没有数据并且还没有到eof阶段，此时如果不跳出，会造成死循环，此时上层将无法填充ByteStream，死循环将一直持续
            + 第二是已经发送出去fin报文
                - 发生这种情况，说明ByteStream没有数据并且已经到eof阶段，不跳出就死循环（和上面有略微差别）
                
    + ack_received
        
        - 功能：收到接收方的ack，通过新的窗口大小及已确认报文序列ackno来进行更新
        
        - 实现：对ackno进行unwrap，之后就是通过此值对未确认队列进行删除，删除时记得重启定时器。最后需要更新窗口大小，因为窗口大小被更新，可能需要重新填充，调用fill_window
        
    + tick
    
        - 功能：每隔一段时间被调用一次，若超时，需要重传最早未被确认的报文段，如果窗口大小为非零（此时可能是因为网络拥塞造成数据包丢失）：
            + 跟踪连续重新传输的次数，并增加它
            + 将RTO的值增加一倍（指数回退）
           之后启动重传timer
           
           
           
## lab4
实验四将之前写的sender和reciever结合起来，实现可以真正和其他世界各地计算机进行对话的tcp协议。
首先熟悉reciever状态：



![tcp_reciever状态](tcp_reciever_state.png)






然后熟悉sender状态：



![tcp_sender状态](tcp_sender_state.png)






最后熟悉tcp状态机：



![tcp状态机](tcp_state.png)






同时阅读理解tcp_state.hh和tcp_state.cc源码。
在能将这三个图片熟悉（甚至背下来）后，关键在于理解三次握手和四次挥手，之后开始写相关函数，我将相关函数分为三类：


    + 连接函数
    
        - remaining_outbound_capacity
        
        - bytes_in_flight
        
        - unassembled_bytes
        
        - time_since_last_segment_received
        
        - active
        
        这几个函数只需要调用reciever或者sender的相关方法即可，或者返回自己设置的变量，如我设置的is_active表示tcp是否存活，较为简单
        
    
    + 填充函数
    
        - write
        
        - end_input_stream
        
        - connect
        
        这三个函数本质都是填充，write是向sender的streamin写字节流，end_input_stream为终止向sender的streamin写字节流，实际上就是向sender的streamin写fin（前面的实验告诉我们fin也         占一个字节），而connect，相当于写一个syn，也占一个字节。这三个函数需要注意在写完字节流或者终止字节流写入后一定要调用fillwindow方法，因为可能此时窗口大小够用，但是streamin却         为空，造成win空闲但是无字节流可写入的局面，此时一定要手动调用fill_window来“唤醒”sender。
        
    + 辅助函数
    
        - add_ack_and_win
        
        - set_rst
        
        这两个函数是自定义函数，起辅助功能，上面的两个个品种函数和下面的是cs144官方给出的接口，不能修改。add_ack_and_win主要是将sender的seg队列中的所有seg移到connection的seg队           列，这样才算是将sender发送的包发送出去了，发送出去之前要注意：加上ackno和win_size，这个方法一定要和fillwindow方法成对出现。而set_rst则是将自生置为错误状态，且根据传入的           bool参数判断是否发送rst包。
        
        
    + 状态相关函数
    
        - segment_received
        
        - tick
        
        这两个函数是tcp的核心，是最难的两个函数，和tcp状态密切相关，前两个品种的函数和状态无关，无需根据状态来采取不同行为。
        
        首先是segment_received函数，注意每次调用此函数首先是将离上一次收到seg的时间清零，之后判断其是否为rst包，是则直接调用set_rst自爆，注意传入false，因为这是被动自爆，无需发送         rst包。随后需要注意判断是否是ack包，如果是，则意味着需要将ackno和win两个参数传给sender，此时如果窗口变大，sender会发送数据包，然后需要判断是否需要发空包，只有在该包不是空的         ack包并且sender的seg队列为空，此时需要调用sender发送一个空包，但是不能立即发送。随后便是对11个状态中接收方最特殊的三个状态进行相应处理，分别是收到syn包、收到fin包和收到             finack包，具体状态的判断见tcp_state.hh和tcp_state.cc源码，但是不能原封不动按上面来判断，需小小改动，嘻嘻。方法最后，如果需要发空包，则发之，注意add_ack_and_win，不论是否         发空包，都需要调用此方法，仔细看我上面说的和add_ack_and_win解析。
        
        然后是tick方法，首先注意此方法开始注意将离上一次收到seg的时间增加，之后调用sender的tick，然后判断是否超时，超时则清空sender的seg队列，并且set_rst自爆，直接返回，注意传入的         参数哦。然后便是调用add_ack_and_win将重传包发送出去。这两个步骤不能颠倒，即不能先发包，再判断是否重传超过最大限制次数。最后需要注意判断是否到了time_wait阶段哦，如果到了此阶         段，if_linger为真，已经过了10倍的初始重传超时(_cfg.rt_timeout)时，即可关闭此tcp连接了。
        
        
        
好了最后便是将你写的所有代码整合起来



![lab4结果](lab4_grades.png)






流量测试，勉强过关



![流量测试](tcp_performance.png)







最后回到梦开始的地方，将webget使用你自己写的tcp协议，和世界各地的计算机对话吧



![webget](webget.png)
    
        
  



    
  
    










   


