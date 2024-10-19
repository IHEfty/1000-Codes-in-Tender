# MewChat

**MewChat** is a simple terminal-based chat application built using the **Tender** programming language for the client-side and **Node.js** for the server-side. It allows multiple clients to connect to a TCP server and send messages to each other in real time.

This project is part of the **1000+ Codes in Tender** repository, showcasing the flexibility and simplicity of **Tender** for handling network communication alongside traditional languages like JavaScript.

## **Features**

- **Real-time Chat**: Multiple clients can connect to the server and exchange messages in real time.
- **JSON-Based Communication**: Messages are encoded and decoded using JSON format for structured communication.
- **Cross-Platform**: Works on both Linux and Windows, as long as **Tender** and **Node.js** are installed.

## **Project Structure**

```
mewchat_td/
│
├── client.td        # Tender-based client code
├── hide_show.td     # Auxiliary code for additional features
└── server/
    └── server.js    # Node.js-based server code
```

## **Getting Started**

To run **MewChat**, you'll need to install both **Tender** and **Node.js**. Follow the steps below to get everything set up and running.

### **1. Install Tender**

Make sure you have **Tender** installed on your machine. If not, you can install **Tender** by running the following command:

```bash
go install github.com/2dprototype/tender/cmd/tender@latest
```

Alternatively, download the precompiled binaries from the [Tender Releases page](https://github.com/2dprototype/tender/releases).

### **2. Install Node.js**

You'll also need **Node.js** to run the server. You can download it from the [official Node.js website](https://nodejs.org/).

### **3. Clone the Repository**

Clone this repository and navigate to the **mewchat_td** directory:

```bash
git clone https://github.com/IHEfty/1000-Codes-in-Tender.git
cd 1000-Codes-in-Tender/examples/mewchat_td
```

### **4. Run the Chat Server**

To start the server, navigate to the `server` directory and run the **server.js** file using **Node.js**:

```bash
cd server
node server.js
```

The server will start listening on **port 3000**, and you should see the following output:

```
Chat server is listening on port 3000
Client connected: ::ffff:127.0.0.1
```

### **5. Run the Client**

In another terminal, run the **client.td** file using **Tender**:

```bash
cd ..
tender client.td
```

After starting the client, you will be prompted to enter your name:

```
Enter your name: <Your Name>
```

Once your name is entered, you can start typing messages, and they will be broadcast to other connected clients.

### **6. Chatting**

You can now chat by typing messages into the terminal. The format of the chat will look like this:

```
>>> hi hello
<Your Name>: hi hello
```

Each message will be tagged with the sender's name and broadcast to other clients.

## **Code Explanation**

### **Client (client.td)**

The client code is written in **Tender** and performs the following tasks:
- Establishes a TCP connection to the server on **localhost:3000**.
- Prompts the user for their name, which will be used to identify their messages.
- Listens for incoming messages from the server and displays them in the terminal.
- Sends user input to the server, encoded in **JSON** format.

Key libraries used:
- `bufio`: For reading input from the user.
- `net`: For managing the TCP connection.
- `json`: For encoding and decoding messages.
- `strings`: For trimming whitespace from user input.
- `colors`: For adding color to the output text (i.e., displaying user names in green).

### **Server (server.js)**

The server code is written in **Node.js** and performs the following tasks:
- Listens for incoming TCP connections on **port 3000**.
- Adds new clients to an array of active clients.
- Broadcasts messages from one client to all others.
- Handles client disconnections and removes them from the client list.
- Logs all events (connections, disconnections, and errors) to the console.

Key functions:
- `broadcastMessage(sender, data)`: Broadcasts a message to all clients except the sender.
- `socket.on('data')`: Listens for incoming messages from a client and processes them.
- `socket.on('end')`: Handles client disconnections.
- `socket.on('error')`: Handles socket errors and cleans up the client list.

## **Explore More**

To know more about **Tender** and explore more projects like **MewChat**, check out the **1000+ Codes in Tender** repository:

[1000+ Codes in Tender](https://github.com/IHEfty/1000-Codes-in-Tender/)

This repository contains a wide range of **Tender** projects and code examples to help you learn and experiment with this unique language.

## **License**

This project is open-source and licensed under the MIT License. You are free to use, modify, and distribute it in your own projects.
