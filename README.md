# CS144 斯坦福2021秋季计算机网络实验
cs144官网：https://kangyupl.gitee.io/cs144.github.io/
参考博客：http://doraemonzzz.com/tags/CS144/    https://kiprey.github.io/tags/CS144/

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
首先应该熟悉tcp状态机，tcp高达11个状态（加上error12），这是cs144官方给的图片：

    
  
    










   


