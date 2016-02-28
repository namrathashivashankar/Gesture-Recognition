%Author : Namratha Shivashankar
%Reference :http://www.mathworks.com/matlabcentral/fileexchange/52259-hu-s-invariant-moments

function KNN_RV()
%Initializing Data
Image = [];
Label_train = [];
k = 20;

homedir = 'C:\Users\Namratha\Documents\MATLAB\Final';
dirs = dir(homedir);
ki = 1;

%% Reading Training Images into a Matrix and Calculating its Invariant Moments
for i =3:length(dirs)
    folder = dirs(i).name;
    filepath = strcat(homedir,'\',folder);
    files = dir(filepath);
    for j = 3:length(files)
        filename = files(j).name;
        img = strcat(filepath,'\',filename);
        rzimg = imresize(imread(img),0.5);
        level = 0.39;
        %imshow(bwareaopen(imcomplement(im2bw(rgb2gray(rzimg),level)),8000));
        eta = SI_Moment(bwareaopen(imcomplement(im2bw(rgb2gray(rzimg),level)),10000));
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
p=0;
g2 = [];
message = sprintf('Do you want to start Testing?');
reply2 = questdlg(message, 'Test?', 'Yes','No','Yes');
cont = 1;
if strcmpi(reply2, 'Yes')
    cam = webcam('Integrated Webcam')
 while(cont ==1) 
   img1 = snapshot(cam); 
   level = 0.39;
   rztimg = imresize(img1,0.5);
   figure;
   imshowpair(img1,bwareaopen(imcomplement(im2bw(rgb2gray(rztimg),level)),10000),'montage');
   eta = SI_Moment(bwareaopen(imcomplement(im2bw(rgb2gray(rztimg),level)),10000));
   inv_moments_test = Hu_Moments(eta);
   [distance,Index] = KNN1(inv_moments_test,inv_moments_train,k);
    keyset = {'G1','G2','G3','G4','G5'};
    valueset= [0 , 0 , 0 , 0 , 0];
    Vote = containers.Map(keyset,valueset);
    for a = 1:3
        Vote(Label_train(Index(a),:)) =  Vote(Label_train(Index(a),:))+1;
    end
        [value,I]= max(cell2mat(values(Vote)));
        keylables = keys(Vote);
        Predcited_Gesture = char(keylables(I));
        g2 = [g2 ;str2double(Predcited_Gesture(2))]
        S = Predcited_Gesture
        htxtins = vision.TextInserter(Predcited_Gesture);
        htxtins.Color = [255, 255, 255]; % [red, green, blue]
        htxtins.FontSize = 24;
        htxtins.Location = [100 315]; % [x y]
        J = step(htxtins,img1);
        figure;
        imshow(J);
        %MyBox = uicontrol('style','text');
        %set(MyBox,'String',Predcited_Gesture);

message1 = 'do you want to continue?'; 
reply2 = questdlg(message, 'Test?', 'Yes','No','Yes');
if strcmpi(reply2, 'Yes')
    cont = 1;
    close all;
else
    cont = 0;
end
 end
end 
if strcmpi(reply2,'No')
    clear cam;
    disp('Before Confusion');
    whos g2
    disp('here!');
    g1 = [1;2;3;4;5;1;2;3;4;5];
    whos g1
    [C,order] = confusionmat(g1,g2)
    figure;
    imagesc(C);
    
end    
    %clear cam;
%end
end
%% 

