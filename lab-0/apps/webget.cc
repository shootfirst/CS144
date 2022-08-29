#include "socket.hh"
#include "util.hh"

#include <cstdlib>
#include <iostream>

using namespace std;

void get_URL(const string &host, const string &path) {
    Address address(host, "http");
    // here we call the socket syscall at the bottom
    TCPSocket sock;
    // we are client so we call connect to build a connection to the server,three-way handshake happens at this time
    sock.connect(address);
    // we write data to server,here write equals to send
    sock.write("GET " + path + " HTTP/1.1\r\n");
    sock.write("Host: " + host + "\r\n");
    sock.write("\r\n");
    // shutdown for write
    sock.shutdown(SHUT_WR);
    string res;
    // here read equals to recv
    string received = sock.read(1);
    while (!sock.eof()) {
        res = res + received;
        received = sock.read(1);
    }
    std::cout << res;
    // close socket, we can also use shutdown
    sock.close();
}

int main(int argc, char *argv[]) {
    try {
        if (argc <= 0) {
            abort();  // For sticklers: don't try to access argv[0] if argc <= 0.
        }

        // The program takes two command-line arguments: the hostname and "path" part of the URL.
        // Print the usage message unless there are these two arguments (plus the program name
        // itself, so arg count = 3 in total).
        if (argc != 3) {
            cerr << "Usage: " << argv[0] << " HOST PATH\n";
            cerr << "\tExample: " << argv[0] << " stanford.edu /class/cs144\n";
            return EXIT_FAILURE;
        }

        // Get the command-line arguments.
        const string host = argv[1];
        const string path = argv[2];

        // Call the student-written function.
        get_URL(host, path);
    } catch (const exception &e) {
        cerr << e.what() << "\n";
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
