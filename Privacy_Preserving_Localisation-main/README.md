# PrivPresLoc
Adam Taras 2022. Work done under Donald G. Dansereau as part of the Robotic Imaging Group, The University of Sydney

This git repo contains a MATLAB implementation of a privacy preserving pipeline. 

### Requirements

We use a modified imds to allow for cleaner dataset managment.
Need to change line in bagOfFeatures to not check type on input 
`parser.addRequired('imds', @(x) true);`

## Datasets

Datasets can be found on [Google Drive](https://drive.google.com/file/d/13gJZODgmu5-J6e-ORR_-c9Mou6VAmvAI/view?usp=share_link)

### Structure

Key folder:
- localisationPipeline: which contains functions for different feature extractors and functions for testing/evaluating them on a given dataset. 

Filename convention:
- m - main file
- x - experiment
- d - modify dataset
- t - function tester


