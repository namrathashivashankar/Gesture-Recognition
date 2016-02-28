function ConfusionMatrix(g2)
whos g2
disp('here!');
%g1 = [1;1;1;1;1;1;2;2;2;2;2;2;3;3;3;3;3;3;4;4;4;4;4;4;5;5;5;5;5;5];
g1 = [1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4;5;5;5;5];
whos g1
[C,order] = confusionmat(g1,g2)
imagesc(C);
end