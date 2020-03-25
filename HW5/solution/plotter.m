clear
load train_accuracy.mat
load train_loss.mat
load test_accuracy.mat

%plot test accuracy
figure
plot(test_accuracy)
xlabel('Epochs')
ylabel('Test Accuracy')
title('Test Accuracy')

%plot train loss
figure
plot(train_loss)
xlabel('Iterations')
ylabel('Train Loss')
title('Training Loss')

%plot train accuracy
figure
plot(train_accuracy)
xlabel('Iterations')
ylabel('Train Accuracy')
title('Training Accuracy')