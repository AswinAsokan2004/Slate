# 🪞 Slate – AI-Powered Hand Gesture Recognition

Slate is a real-time **AI-based gesture recognition system** that predicts letters from hand gestures using a trained deep learning model. It comes with a **Flutter frontend** for a smooth user interface and a **Python backend** for AI inference.

---

## 📂 Project Structure

```
frontend/slate/lib/main.dart   # Flutter frontend entry point
backend/main.py                # Python backend entry point
model/gesture_model.tflite     # Trained gesture recognition model
```

> The trained model can be downloaded here: [Gesture Model](https://drive.google.com/file/d/1yjp72ozSd7CQzlsVyVubqn9pd3jfIQqu/view?usp=sharing)

---

## 🚀 Features

* **Real-time Gesture Detection** – Captures hand gestures via camera.
* **Letter Prediction** – Predicts the corresponding letter for the detected gesture.
* **Smooth UI** – Built with Flutter for an intuitive experience.
* **Fast Backend Processing** – Python backend with TensorFlow Lite model.

---

## 🛠 Installation

### Backend

```bash
cd backend
pip install -r requirements.txt
python main.py
```

### Frontend

```bash
cd frontend/slate
flutter pub get
flutter run
```

---

## 🔮 How It Works

1. The frontend captures the video stream from the camera.
2. The backend processes frames using the trained AI model.
3. Predicted letters are sent back to the frontend in real time.

---

## 📜 License

This project is licensed under the MIT License.
