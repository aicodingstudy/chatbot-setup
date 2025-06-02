# Local Chatbot App (macOS)

This repository contains a minimal example of a Swift-based macOS chatbot application that communicates with a locally hosted large language model (LLM). The goal is to keep all chat interactions private by running the model entirely on your MacBook.

If you are interested in running a similar chatbot **directly on an iPhone**, see the [iOS local LLM guide](docs/iOS-local-LLM.md) for an outline of the additional steps.

## Components

1. **SwiftUI App (`ChatbotApp`)**
   - Simple chat interface with a text input field and send button.
   - Messages are displayed in a scrollable view for the current session only.
   - Communicates with a local HTTP server to get responses from the LLM.

2. **Python Backend (`backend/server.py`)**
   - Uses `llama-cpp-python` to run an open-source LLM such as LLaMA or Mistral locally.
   - Exposes a `/chat` endpoint that accepts a prompt and returns the model's reply.

## Prerequisites

- **macOS** (tested on recent macOS versions).
- **Xcode** with Swift 5 for building the GUI.
- **Python 3** installed with `pip`.

## Setup

1. **Install Python dependencies**

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install flask llama-cpp-python
   ```

2. **Download an LLM model**

   Obtain a compatible `ggml`/`gguf` model file for your chosen LLM. Place the path to this file when launching the server.

3. **Run the backend server**

   ```bash
   python backend/server.py --model /path/to/your/model.gguf
   ```

   The server will listen on `http://localhost:8000`.

4. **Build and run the Swift app**

   You can open `ChatbotApp/Package.swift` in Xcode or build with Swift Package Manager:

   ```bash
   cd ChatbotApp
   swift run
   ```

   A window will appear where you can type messages and receive replies from the local model.

## Notes

- This is an MVP example. There is no persistent chat history or user accounts.
- All computation happens locally for privacy and offline use.
- Depending on your model size, you may need sufficient RAM and disk space.

## Future Improvements

- Persistent chat logs
- Model configuration within the app
- Speech-to-text or additional UI features
- Sharing or exporting conversations
