# CS144 斯坦福2021秋季计算机网络实验

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






   


