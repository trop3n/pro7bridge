import websockets
import asyncio
import json
import requests
from urllib.parse import urljoin

# Configuration
API_WS_URL = "ws://localhost:50001/"
HTTP_ENDPOINT = "https://your-api-endpoint.com/slide-changed"

async def listen_for_slide_changes():
    while True: # Reconnection loop
        try:
            async with websockets.connect(API_WS_URL) as websocket:
                print("Connected to ProPresenter API")

                # Subscribe to slide change events
                subscribe_msg = json.dumps({
                    "action": "subscribe",
                    "events": ["presentationSlideChanged"]
                })
                await websocket.send(subscribe_msg)

                # listen
                async for message in websocket:
                    data = json.loads(message)

                    if data.get("event") == "presentationSlideChanged":
                        slide_data = data.get("data", {})
                        print(f"Slide changed: {slide_data}")
