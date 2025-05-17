import argparse
from flask import Flask, request
from llama_cpp import Llama

app = Flask(__name__)
llm = None

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()
    prompt = data.get('prompt', '')
    if llm is None:
        return 'Model not loaded', 500
    result = llm(prompt)
    return result['choices'][0]['text']

def main(model_path: str):
    global llm
    llm = Llama(model_path=model_path)
    app.run(host='127.0.0.1', port=8000)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Run local LLM server')
    parser.add_argument('--model', required=True, help='Path to GGML model file')
    args = parser.parse_args()
    main(args.model)
