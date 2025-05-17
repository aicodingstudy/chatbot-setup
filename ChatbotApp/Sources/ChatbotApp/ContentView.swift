import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""

    func sendMessage() {
        let userMessage = Message(text: inputText, isUser: true)
        messages.append(userMessage)

        callLLM(prompt: inputText) { response in
            DispatchQueue.main.async {
                let botMessage = Message(text: response, isUser: false)
                self.messages.append(botMessage)
            }
        }

        inputText = ""
    }

    func callLLM(prompt: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "http://localhost:8000/chat") else {
            completion("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["prompt": prompt], options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let result = String(data: data, encoding: .utf8) {
                completion(result)
            } else {
                completion(error?.localizedDescription ?? "No response")
            }
        }.resume()
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.isUser { Spacer() }
                            Text(message.text)
                                .padding()
                                .background(message.isUser ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            if !message.isUser { Spacer() }
                        }
                        .padding(.vertical, 2)
                        .id(message.id)
                    }
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let last = viewModel.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
            HStack {
                TextField("Type message...", text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.sendMessage()
                }
                .disabled(viewModel.inputText.isEmpty)
            }
            .padding()
        }
        .frame(minWidth: 400, minHeight: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
