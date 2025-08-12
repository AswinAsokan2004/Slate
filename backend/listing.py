import os
import cv2
import numpy as np

# Path to your dataset
DATASET_PATH = "dataset"

# Label mapping
label_map = {'a': 0, 'e': 1, 'o': 2}

X = []  # images
y = []  # labels

# Load and process images
for label_name in os.listdir(DATASET_PATH):
    label_path = os.path.join(DATASET_PATH, label_name)
    if not os.path.isdir(label_path):
        continue
    for img_name in os.listdir(label_path):
        img_path = os.path.join(label_path, img_name)
        try:
            img = cv2.imread(img_path)  # Load in color
            img = cv2.resize(img, (64, 64))  # Resize to 64x64
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)  # Convert to grayscale
            _, bw = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)  # Binarize image
            bw = bw / 255.0  # Normalize to 0 and 1
            X.append(bw)
            y.append(label_map[label_name])
        except Exception as e:
            print(f"Error loading {img_path}: {e}")

X = np.array(X).reshape(-1, 64, 64, 1)  # For CNN input
y = np.array(y)

print("Data shape:", X.shape, y.shape)

# Save to .npz file
np.savez("malayalam_dataset.npz", X=X, y=y)
