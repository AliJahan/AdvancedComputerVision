import os
import numpy as np
import scipy.io as sio
import glob
import numpy as np
import torchvision.transforms as transforms
import torchvision
import torch.nn as nn
from PIL import Image


# SPECIFY PATH TO THE DATASET
from torch.autograd import Variable

path_to_dataset = './tiny-UCF101/'

def main():

    feature = []
    label = []
    categories = sorted(os.listdir(path_to_dataset))

    transform_test = transforms.Compose([
        transforms.Resize(256),     #used instead of Scale
        transforms.CenterCrop(224), #used instead of Scale
        # transforms.Scale(224),    #Depreciated
        transforms.ToTensor(),
        transforms.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010)),
    ])

    # FILL IN TO LOAD THE ResNet50 MODEL
    extractor = torchvision.models.resnet50(pretrained=True)
    extractor.eval()
    for i, c in enumerate(categories):
        path_to_images = sorted(glob.glob(os.path.join(path_to_dataset,c) + '/*.jpg'))
        for p in path_to_images:
            # FILL IN TO LOAD IMAGE, PREPROCESS, EXTRACT FEATURES.
            # OUTPUT VARIABLE F EXPECTED TO BE THE FEATURE OF THE IMAGE OF DIMENSION (2048,)
            img = Image.open(p)
            img_tnsr = transform_test(img).float()
            img_tnsr = img_tnsr.unsqueeze_(0)

            # remove last fully-connected layer
            new_classifier = nn.Sequential(*list(extractor.children())[:-1])
            out = new_classifier(Variable(img_tnsr))
            conv_out = out.detach().numpy()
            F = conv_out[0, :, 0, 0]
            feature.append(F)
            label.append(categories.index(c))
        #print(i)
    #print(len(feature))
    #print(feature[0].shape)
    #print(len(label))

    sio.savemat('ucf101dataset.mat', mdict={'feature': feature, 'label': label})


if __name__ == "__main__":
    main()
