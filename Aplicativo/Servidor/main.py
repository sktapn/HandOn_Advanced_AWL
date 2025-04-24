import cv2
from flask import Flask, Response, render_template, jsonify
from face import detect_faces
import time

app = Flask(__name__)

stream_url = "rtsp://admin:N3T1PD56@192.168.1.11:554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif"
face_count = 0

def generate_frames(with_faces=True):
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

            if frame is None:
                print("Frame vazio recebido. Pulando...")
                continue

            if with_faces:
                try:
                    frame, count = detect_faces(frame)
                    face_count = count
                    print(f"Detectados {face_count} rostos no frame")
                except Exception as e:
                    print(f"Erro na detecção de rostos: {e}")
                    face_count = 0  # Resetar face_count em caso de erro
            else:
                count = 0  # Não detecta rostos no stream raw

            ret, buffer = cv2.imencode('.jpg', frame)
            if not ret:
                print("Erro ao codificar o frame")
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

@app.route('/video_feed_with_faces')
def video_feed_with_faces():
    return Response(generate_frames(with_faces=True),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/video_feed_raw')
def video_feed_raw():
    return Response(generate_frames(with_faces=False),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/face_count')
def get_face_count():
    return jsonify({'faceCount': face_count})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)