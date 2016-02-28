
function KNN_RV()
%Initializing Data
Image = [];
Label_train = [];
g2 = [];
k = 3;

homedir = 'C:\Users\Namratha\Documents\MATLAB\Gestrures';
dirs = dir(homedir);
ki = 1;

%% Reading Training Images into a Matrix and Calculating its Invariant Moments
for i =3:length(dirs)
    folder = dirs(i).name;
    filepath = strcat(homedir,'\',folder,'\','Training');
    files = dir(filepath);
    for j = 3:length(files)
        filename = files(j).name;
        img = strcat(filepath,'\',filename);
        rzimg = imresize(imread(img),0.25);
        eta = SI_Moment(roicolor(rzimg(:,:,1),92.583,125.8333));
        inv_moments_train(ki,:) = Hu_Moments(eta);
        %whos folder
        Label_train = [Label_train ; char(folder)]
        ki = ki+1;
    end
end
assignin('base', 'inv_moments_train',inv_moments_train);
assignin('base', 'Label_train',Label_train);
assignin('base', 'k',k);
%% Testing
g2 =[];
for i =3:length(dirs)
    folder = dirs(i).name;
    filepath = strcat(homedir,'\',folder,'\','Test');
    files = dir(filepath);
    for j = 3:length(files)
        filename = files(j).name;
        img = strcat(filepath,'\',filename);
        rztimg = imresize(imread(img),0.25);
        eta = SI_Moment(roicolor(rztimg(:,:,1),92.583,125.8333));
        inv_moments_test = Hu_Moments(eta);
        [distance,Index] = KNN1(inv_moments_test,inv_moments_train,k);
        keyset = {'G1','G2','G3','G4','G5'};
        valueset= [0 , 0 , 0 , 0 , 0];
        Vote = containers.Map(keyset,valueset);
        for a = 1:3
            Vote(Label_train(Index(a),:)) =  Vote(Label_train(Index(a),:))+1;
        end
        [value,I]= max(cell2mat(values(Vote)))
        keylables = keys(Vote);
        Predcited_Gesture = char(keylables(I));
        g2 = [g2 ;str2double(Predcited_Gesture(2))]
        ksmallestelements = distance(1);
        index_predicted_image = Index(1);
        Predcited_Gesture = Label_train(index_predicted_image,:);
        Predicted_Image = strcat(homedir,'\',Predcited_Gesture,'\','Training','\','3.jpg');
        A = imread(img);
        B = imread(Predicted_Image);
        position =  [100 850];
        value = 'Predicted Gesture';
        RGB = insertText(B,position,value,'FontSize',100,'AnchorPoint','LeftBottom');
        figure;
        imshowpair(A,RGB,'montage');
        pause(4);
       close all;
    end
end


ConfusionMatrix(g2);
end
%% 
 
% function [ksmallestelements,index] = KNN(inv_moments_test,inv_moments_train,k)
%     
%     for l = 1:size(inv_moments_train,1)
%         dist(l,:) = norm(inv_moments_test-inv_moments_train(l,:));
%     end
%     [min_dist,I] =  sort(dist);
%     ksmallestelements = min_dist(1:k);
%     index = I(1:k);  
%     
% end
