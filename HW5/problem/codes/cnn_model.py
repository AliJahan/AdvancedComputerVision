########################################################################
# 2. DEFINE YOUR CONVOLUTIONAL NEURAL NETWORK
########################################################################

import torch.nn as nn
import torch.nn.functional as F


class ConvNet(nn.Module):
    def __init__(self, init_weights=False):
        super(ConvNet, self).__init__()
        self.conv1 = 
        self.conv2 = 
        self.conv3 = 
        self.conv4 = 
        self.drop_out = nn.Dropout()
        self.fc1 = 
        self.fc2 = 
        
        if init_weights:
            self._initialize_weights()

    def forward(self, x):
        out = 
        return out

    def _initialize_weights(self):
        for m in self.modules():
            if isinstance(m, nn.Conv2d):
                nn.init.kaiming_normal_(m.weight, mode='fan_out', nonlinearity='relu')
                if m.bias is not None:
                    nn.init.constant_(m.bias, 0)
            elif isinstance(m, nn.BatchNorm2d):
                nn.init.constant_(m.weight, 1)
                nn.init.constant_(m.bias, 0)
            elif isinstance(m, nn.Linear):
                nn.init.normal_(m.weight, 0, 0.01)
                nn.init.constant_(m.bias, 0)

