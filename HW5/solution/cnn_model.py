########################################################################
# 2. DEFINE YOUR CONVOLUTIONAL NEURAL NETWORK
########################################################################

import torch.nn as nn
import torch.nn.functional as F


class ConvNet(nn.Module):
    def __init__(self, init_weights=False):
        super(ConvNet, self).__init__()
        out_channels = [16, 32, 64, 128]                                            # output channels for each layer
        self.conv1 = nn.Sequential(                                                 # input shape (3, 32, 32)
                        nn.Conv2d(
                            in_channels=3,                                          # input height
                            out_channels=out_channels[0],                           # n_filters
                            kernel_size=5,                                          # filter size
                            stride=1,                                               # filter movement/step
                            padding=2,                                              # if want same width and length of this image after Conv2d, padding=(kernel_size-1)/2 if stride=1
                        ),                                                          # output shape (16, 32, 32)
                        nn.ReLU(),                                                  # activation
                        nn.Dropout(0.2),                                            # dropout
                        nn.BatchNorm2d(out_channels[0]),                            # batch normalization
                        nn.MaxPool2d(kernel_size=2),                                # choose max value in 2x2 area, output shape (16, 16, 16)
                     )
        self.conv2 = nn.Sequential(                                                 # input shape (16, 16, 16)
                        nn.Conv2d(out_channels[0], out_channels[1], 5, 1, 2),       # output shape (32, 16, 16)
                        nn.ReLU(),                                                  # activation
                        nn.Dropout(0.2),                                            # dropout
                        nn.BatchNorm2d(out_channels[1]),                            # batch normalization
                        nn.MaxPool2d(kernel_size=2),                                # choose max value in 2x2 area, output shape (32, 8, 8)
                     )
        self.conv3 = nn.Sequential(                                                 # input shape (32, 8, 8)
                        nn.Conv2d(out_channels[1], out_channels[2], 5, 1, 2),       # output shape (64, 8, 8)
                        nn.ReLU(),                                                  # activation
                        nn.Dropout(0.2),                                            # dropout
                        nn.BatchNorm2d(out_channels[2]),                            # batch normalization
                        nn.MaxPool2d(kernel_size=2),                                # choose max value in 2x2 area, output shape (64, 4, 4)
                     )
        self.conv4 = nn.Sequential(                                                 # input shape (64, 4, 4)
                        nn.Conv2d(out_channels[2], out_channels[3], 5, 1, 2),       # output shape (128, 4, 4)
                        nn.ReLU(),                                                  # activation
                        nn.Dropout(0.2),                                            # dropout
                        nn.BatchNorm2d(out_channels[3]),                            # batch normalization
                        nn.MaxPool2d(kernel_size=2),                                # choose max value in 2x2 area, output shape (128, 2, 2)
                     )
        self.fc1 = nn.Linear(out_channels[3] * 2 * 2, 100)                          # hidden layer, output 100
        self.drop_out = nn.Dropout(0.5)
        self.fc2 = nn.Linear(100, 10)                                               # fc layer, output 10 classes
        
        if init_weights:
            self._initialize_weights()

    def forward(self, x):
        out = self.conv1(x)
        out = self.conv2(out)
        out = self.conv3(out)
        out = self.conv4(out)
        out = out.view(out.size(0), -1) # flatten the output of conv2 to (batch_size, 128 * 2 * 2)
        out = self.fc1(out)
        out = self.fc2(out)
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

