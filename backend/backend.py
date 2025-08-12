import os
import uuid
from flask import Flask, request, jsonify
from flask_cors import CORS
from werkzeug.utils import secure_filename
import cv2
import numpy as np
from tensorflow.keras.models import load_model

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = 'analyser'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

# Create upload directory if it doesn't exist
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


# Load the trained model
model = load_model("malayalam_cnn_model.h5")

# Reverse mapping: index to label
label_map_rev = {0: 'a', 1: 'e', 2: 'o'}

# Helper: Check allowed file types
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Helper: Generate unique filename
def unique_filename(original_filename):
    ext = original_filename.rsplit('.', 1)[1].lower()
    name = original_filename.rsplit('.', 1)[0]
    unique_id = uuid.uuid4().hex[:8]  # short unique ID
    return f"{secure_filename(name)}_{unique_id}.{ext}"


def predict_image(img_path):
    img = cv2.imread(img_path)
    
    if img is None:
        print(f"❌ Error: Could not load image at {img_path}")
        return

    img = cv2.resize(img, (64, 64))
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    _, bw = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)
    bw = bw / 255.0
    bw = bw.reshape(1, 64, 64, 1)

    prediction = model.predict(bw)
    predicted_class = np.argmax(prediction)
    if max(prediction[0])*100 > 50:
        status = 'valid'
        print('valid')
    else:
        print('invalid')
        status = 'invalid'

    print(f"✅ Predicted Label: {label_map_rev[predicted_class]}")
    print(f"🔢 Prediction Probabilities: {prediction}")
    return label_map_rev[predicted_class], status


@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image part in the request'}), 400

    file = request.files['image']

    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    if file and allowed_file(file.filename):
        filename = unique_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        print(len(os.listdir(UPLOAD_FOLDER)))
        prediction, status = predict_image(filepath)
        return jsonify({'message': 'Image uploaded successfully', 'filename': filename, 'status':status, "prediction":prediction}), 200

    return jsonify({'error': 'Invalid file type'}), 400

if __name__ == '__main__':
    app.run(debug=True)
