# MewChat

**MewChat** is a terminal-based chat application using **Tender** for the client-side and **Node.js** for the server-side, allowing multiple clients to communicate in real time.

## Features

- **Real-time Messaging**: Multiple clients can send and receive messages instantly.
- **JSON Communication**: Messages are structured in JSON format for efficient communication.
- **Cross-Platform**: Works on both **Linux** and **Windows**.

## How It Works

- **Client**: Written in **Tender**, the client connects to the **Node.js** server over TCP. After entering a name, users can send and receive messages, displayed in the terminal.
- **Server**: The **Node.js** server listens on port 3000, handles incoming client connections, and broadcasts messages to all connected clients.

### To Run

1. **Install Tender**: Follow the [installation guide](https://github.com/2dprototype/tender).
2. **Install Node.js**: [Download here](https://nodejs.org).
3. **Clone Repo**: 
   ```bash
   git clone https://github.com/IHEfty/1000-Codes-in-Tender.git
   cd 1000-Codes-in-Tender/examples/mewchat
   ```
4. **Start Server**: 
   ```bash
   node server/server.js
   ```
5. **Start Client**: 
   ```bash
   tender client.td
   ```
6. **Chat**: After entering your name, you can start chatting with others.
