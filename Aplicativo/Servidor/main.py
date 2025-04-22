import cv2
from flask import Flask, Response, render_template, jsonify
from face import detect_faces
import time

app = Flask(__name__)

# URL do fluxo RTSP
rtsp_url = os.environ.get("RTSP_URL")

# Variável global para contagem de rostos (usada pelo serviço Flutter)
face_count = 0

def generate_frames():
    global face_count
    while True:
        cap = cv2.VideoCapture(stream_url)

        if not cap.isOpened():
            print("Erro: Não foi possível abrir o fluxo RTSP")
            time.sleep(5)
            continue

        while cap.isOpened():
            success, frame = cap.read()
            if not success:
                print("Erro ao ler o frame. Tentando reconectar...")
                break

            # Detectar rostos
            frame, count = detect_faces(frame)
            face_count = count  # Atualiza o contador global

            ret, buffer = cv2.imencode('.jpg', frame)
            if not ret:
                continue
            frame = buffer.tobytes()

            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

        cap.release()
        print("Reconectando ao stream RTSP...")
        time.sleep(2)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/face_count')
def get_face_count():
    return jsonify({'faceCount': face_count})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
