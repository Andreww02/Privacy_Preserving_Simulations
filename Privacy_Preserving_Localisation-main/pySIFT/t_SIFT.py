# -*- coding: utf-8 -*-
"""
Created on Wed Mar  9 14:36:47 2022

@author: Adam
"""

import pySIFT
import cv2

import matplotlib.pyplot as plt


image = cv2.imread('myCameraMan.png', 0)
# =============================================================================
# image = image.astype('float32')/255.
# =============================================================================
keypoints, descriptors = pySIFT.computeKeypointsAndDescriptors(image)


keypointsSorted = sorted(keypoints, key=lambda x: x.response, reverse=True)
print(keypointsSorted[0].response)
print(keypointsSorted[1].response)
print(keypointsSorted[2].response)



plt.rcParams["figure.figsize"] = [7.00, 3.50]
plt.rcParams["figure.autolayout"] = True
fig, ax = plt.subplots()
ax.imshow(image)


for i in range(20):
    plt.plot(*keypointsSorted[i].pt, 'rx')


plt.show()