import pandas as pd
import sklearn
import matplotlib  # Add this line
from sklearn.model_selection import train_test_split, cross_val_score, KFold
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
import numpy as np

# ... rest of your code ...

print("Pandas version:", pd.__version__)
print("Scikit-learn version:", sklearn.__version__)
print("Matplotlib version:", matplotlib.__version__)  # This will now work
print("NumPy version:", np.__version__)

# Specify the full path to the Excel file
file_path = 'E:\\Machine Learning\\ML Project\\GSA.xlsx'

# Load the data using the correct file_path
data = pd.read_excel(file_path)

# Define the features and the target
features = [
    'b', 'b1', 'b2', 'd1', 'd2', 'gamma1', 'gamma2', 'u1', 'u2',
    'w1', 'w2', 'g1', 'g2', 'sigma1', 'sigma2', 'p', 'eta', 'r', 'c', 'm', 'a'
]
X = data[features]
y = data['R01']  # Assuming 'maxPr1' is the correct column in your Excel file

# Normalize the features
scaler = StandardScaler()
X_normalized = scaler.fit_transform(X)

# Split the dataset into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X_normalized, y, test_size=0.2, random_state=42)

# Initialize the Random Forest Regressor
model = RandomForestRegressor(n_estimators=100, random_state=42)

# Specify KFold cross-validation with shuffling
cv = KFold(n_splits=5, shuffle=True, random_state=42)

# Perform K-fold cross-validation
cv_scores = cross_val_score(model, X_normalized, y, cv=cv)

# Print the cross-validation scores and their mean
print("Cross-validation scores: ", cv_scores)

# Train the model
model.fit(X_train, y_train)

# Predict on the test set
y_pred = model.predict(X_test)

# Calculate the Mean Squared Error
mse = mean_squared_error(y_test, y_pred)
print(f"Mean Squared Error: {mse}")

# Get feature importances
importances = model.feature_importances_
indices = np.argsort(importances)[::-1]

# Plot the feature importances
plt.figure(figsize=(15, 5))
plt.title('Feature Importances')
plt.bar(range(X_train.shape[1]), importances[indices], align='center')
plt.xticks(range(X_train.shape[1]), [features[i] for i in indices], rotation=90)
plt.xlim([-1, X_train.shape[1]])
plt.tight_layout()
plt.show()

# Print the five most influential parameters
print("Five most influential parameters on maxPr1:")
for i in range(5):
    print(f"{features[indices[i]]}: {importances[indices[i]]}")
