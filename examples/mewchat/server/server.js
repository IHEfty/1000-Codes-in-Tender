const net = require('net');

const clients = [];

const server = net.createServer((socket) => {
    console.log('Client connected:', socket.remoteAddress);
	
    broadcastMessage(socket, { sender: 'Server', text: 'someone joined the chat' });
	
    clients.push(socket);
	
    socket.on('data', (data) => {
        const message = JSON.parse(data.toString())
        broadcastMessage(socket, { sender: socket.remoteAddress, text : message.text, name : message.name });
	});
	
    socket.on('end', () => {
        console.log('Client disconnected:', socket.remoteAddress);
        clients.splice(clients.indexOf(socket), 1);
        broadcastMessage(null, { sender: 'Server', message: ' left the chat' });
	});
	
    socket.on('error', (err) => {
        console.error(`Socket error from ${socket.remoteAddress}: ${err.message}`);
        clients.splice(clients.indexOf(socket), 1);
        broadcastMessage(null, { sender: 'Server', message: `Error from ${socket.remoteAddress}: ${err.message}` });
        socket.destroy(); 
	});
});

function broadcastMessage(sender, data) {
    const formattedMessage = JSON.stringify(data);
    clients.forEach(client => {
        if (client != sender) {
            client.write(formattedMessage);
		}
	});
}

server.on('error', (err) => {
    console.error('Server error:', err.message);
});

const PORT = 3000;

server.listen(PORT, () => {
	console.log(`Chat server is listening on port ${PORT}`);
});

