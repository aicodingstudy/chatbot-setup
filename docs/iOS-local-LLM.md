# Running a Local LLM on iOS

This guide describes how to adapt the sample Swift app in this repository so it can run a quantized large language model (LLM) entirely on an iPhone. The goal is to remove network dependencies and execute all inference on the device.

### Quick Start
1. You need a Mac with Xcode to build the iOS app.
2. Clone this repository and follow the [setup instructions](../README.md) to download a model and run the backend locally.
3. Then follow the sections below to compile the model runtime and integrate it into a SwiftUI project that targets your iPhone.

## 1. Choose a Runtime

- **llama.cpp** is the most widely used library for running lightweight LLMs locally. It supports building for iOS through its C/C++ codebase and Metal.
- **mlc-llm** is another option that provides an iOS deployment guide. Either library can be built as a static library and linked into a Swift project.

## 2. Prepare the Model

1. Quantize the model to reduce file size and memory usage (e.g., 4-bit or 8-bit). Tools like `llama.cpp` provide scripts for this.
2. Ensure the quantized model file is in `gguf` or a similar format supported by the chosen runtime.
3. Add the model file to the app bundle or implement a download step.

## 3. Integrate with Swift

1. Build the C/C++ inference library for iOS (e.g., using Xcode or a Makefile).
2. Create an Objective-C or C bridging header in the SwiftUI project.
3. Expose a simple API in Swift for sending prompts and receiving responses. This can be wrapped in an `ObservableObject` for SwiftUI views.

Example bridging header (`ChatbotApp/llama_bridge.h`):
```c
void *llama_create(const char *model_path);
const char *llama_infer(void *ctx, const char *prompt);
```
Implement these functions using the llama.cpp C API and call them from Swift.

## 4. Build the UI

Use SwiftUI to implement a minimal chat interface:

- A `TextField` for entering prompts.
- A `ScrollView` to display conversation history.
- A `Send` button that triggers inference using the local model.

Ensure that all inference calls happen on a background thread to avoid blocking the UI.

## 5. Testing on Device

- Build and run the app on an iPhone 12 Pro Max using Xcode.
- Confirm that responses are generated without any network connection.
- Monitor memory usage; you may need to adjust model size or quantization level for smooth performance.

## 6. Optional Features

- Allow switching between multiple models in the app settings.
- Support importing or exporting chat logs.
- Provide preset prompts or other productivity features.

With these steps, your junior SWE can extend this repository to deliver a fully offline iOS chatbot powered by a locally hosted LLM.

If you are new to iOS development, consider starting from the [llama.cpp iOS example](https://github.com/ggerganov/llama.cpp/tree/master/examples/ios) which provides a prebuilt Xcode project.
