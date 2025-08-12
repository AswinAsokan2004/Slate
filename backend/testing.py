# import cv2
# import numpy as np
# from tensorflow.keras.models import load_model

# # Load the trained model
# model = load_model("malayalam_cnn_model.h5")

# # Reverse mapping: index to label
# label_map_rev = {0: 'a', 1: 'e', 2: 'o'}

# def predict_image(img_path):
#     # Load image
#     img = cv2.imread(img_path)
#     img = cv2.resize(img, (64, 64))
#     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
#     # Binarize (black and white)
#     _, bw = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)
#     bw = bw / 255.0  # Normalize to 0 or 1
#     bw = bw.reshape(1, 64, 64, 1)  # Reshape for CNN

#     # Predict
#     prediction = model.predict(bw)
#     predicted_class = np.argmax(prediction)
    
#     print(f"Predicted Label: {label_map_rev[predicted_class]}")
#     print(f"Prediction Probabilities: {prediction}")

# # Example usage
# predict_image("dataset\a\drawing_e98cbe36.png")



import cv2
import numpy as np
from tensorflow.keras.models import load_model

# Load the trained model
model = load_model("malayalam_cnn_model.h5")

# Reverse mapping: index to label
label_map_rev = {0: 'a', 1: 'e', 2: 'o'}

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
        print('valid')
    else:
        print('Invalid')

    print(f"✅ Predicted Label: {label_map_rev[predicted_class]}")
    print(f"🔢 Prediction Probabilities: {prediction}")

# Use correct path format
predict_image(r"dataset\o\drawing_61f3ebb3.png")
