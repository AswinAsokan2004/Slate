# 🖍️ Slate – Malayalam Letter Recognition for Kids

Slate is an **interactive learning application** designed especially for **kids and new Malayalam learners**. It uses an **ensemble CNN model** trained to recognize Malayalam letters from user-drawn inputs. The app provides an engaging and educational environment for children to practice writing Malayalam characters and receive instant feedback.

---

## 📌 Features

* **Kid-friendly Interface** – Simple, colorful, and intuitive.
* **Malayalam Letter Recognition** – Detects letters drawn on screen.
* **Real-time Feedback** – If the recognition probability is low, the app will suggest **"Try Again"**.
* **CNN-based Ensemble Model** – Accurately identifies Malayalam letters from hand-drawn input.
* **Interactive Drawing Board** – Users can draw a letter, which is then processed by the model.
* **Offline Support** – Works locally after model download.

---

## 🏗️ Project Structure

```
Slate/
├── frontend/
│   └── slate/lib/main.dart       # Flutter frontend main file
├── backend/
│   └── main.py                   # Python backend API server
└── model/
    └── malayalam_cnn_model       # Ensemble CNN model for letter recognition
```

---

## 🚀 How It Works

1. **User Draws a Letter** – On the digital slate in the frontend.
2. **Image Capture** – The drawing is captured and sent to the backend.
3. **Model Prediction** – The backend loads the trained CNN ensemble model.
4. **Result Display** – If the probability is high, the predicted letter is shown. If low, the app says **"Try Again"**.

---

## 📥 Model Download

The trained ensemble CNN model can be downloaded here:
[📎 Download Malayalam CNN Model](https://drive.google.com/file/d/1yjp72ozSd7CQzlsVyVubqn9pd3jfIQqu/view?usp=sharing)

After downloading, place the model file in the `model/` directory inside the backend folder.

---

## 🛠️ Installation & Setup

### 1️⃣ Clone the Repository

```bash
git clone <repository-url>
cd Slate
```

### 2️⃣ Backend Setup (Python)

```bash
cd backend
pip install -r requirements.txt
python main.py
```

### 3️⃣ Frontend Setup (Flutter)

```bash
cd frontend/slate
flutter pub get
flutter run
```

---

## 🖥️ Tech Stack

* **Frontend:** Flutter (Dart)
* **Backend:** Python (Flask/FastAPI)
* **Model:** Convolutional Neural Network (CNN) Ensemble
* **Target Audience:** Kids and Malayalam beginners

---

## 📚 Future Improvements

* Add support for **all Malayalam compound letters**.
* Improve accuracy for **imperfect handwriting**.
* Add **voice feedback** for correct/incorrect predictions.

---

## 👨‍💻 Author

Developed with ❤️ for children learning Malayalam.
