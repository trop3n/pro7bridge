const WebSocket = require('ws');
const axios = require('axios');

function connectToProPresenter() {
    const ws = new WebSocket('ws://localhost:50001/');

    ws.on('open', () => {
        console.log('Connected!');
        ws.send(JSON.stringify({
            action: "subscribe",
            events: ["presentationSlideChanged"]
        }))
    });

    ws.on('message', (data) => {
        const msg = JSON.parse(data);
        if(msg.event === 'presentationSlideChanged') {
            console.log('Slide changed', msg.data);
            // Send HTTP request
            axios.post('https://your-api.com/slide-changed', msg.data)
              .catch(err => console.error('HTTP Error:', err));
        }
    });

    ws.on('error', (err) => {
      console.error('Websocket Error:', err);
    });

    ws.on('close', () => {
      console.log('Reconnecting in 5 seconds...');
      setTimeout(() => connectToProPresenter(), 5000);
    });
}

// Start initial connection
connectToProPresenter();