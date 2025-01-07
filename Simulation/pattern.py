import numpy as np
import matplotlib.pyplot as plt

# Parameters
radius_max = 5  # Maximum radius
increment = 5
steps = 360 // increment     # Number of lines
points_per_line = 100  # Points along each radial line

# Initialize arrays to store the pattern
x_values = []
y_values = []

# Generate pattern
angles = np.linspace(0, 2 * np.pi, steps, endpoint=False)  # Angles in radians
for angle in angles:
    r = np.linspace(0, radius_max, points_per_line)  # Ramp signal for radius
    x = r * np.cos(angle)  # X-coordinates
    y = r * np.sin(angle)  # Y-coordinates
    x_values.extend(x)
    y_values.extend(y)

# Plot the pattern
plt.figure(figsize=(8, 8))
plt.plot(x_values, y_values, color='blue', linewidth=0.5)
plt.title("Laser Galvo Pattern")
plt.xlabel("X-axis (Voltage)")
plt.ylabel("Y-axis (Voltage)")
plt.axis("equal")
plt.grid()
plt.show()
