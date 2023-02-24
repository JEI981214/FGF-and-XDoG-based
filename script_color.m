%% COLOR

close all;
clear all;
clc;


% [imagename1 imagepath1]=uigetfile('\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
% A=imread(strcat(imagepath1,imagename1)); 
% [imagename2 imagepath2]=uigetfile('\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
% B1=imread(strcat(imagepath2,imagename2));  
A=imread('25-1MRI (1).png');
B1=imread('25-2PET (2).png');


A=im2double(A);
B1=im2double(B1);
figure,imshow(A,'border','tight');
figure,imshow(B1,'border','tight');
input1=A;
input2=B1;
tic
if size(A,3)>1
    A=rgb2gray(A);        
end

[hei, wid] = size(A);
[row,column]=size(A);
%% Converting
B_YUV=ConvertRGBtoYUV(B1);   
B1=B_YUV(:,:,1);            

B=B1;
%%  Initail fusion
map1=abs(A>B);
F1=A.*map1+~map1.*B;
G=fspecial('average',10);
F1_L=imfilter(F1,G);
F1_H=F1-F1_L;
%% Detail layers
A_L=imfilter(A,G);
B_L=imfilter(B,G);

A_H=A-A_L;
B_H=B-B_L;


%% Detail extraction using XDoG
Gamma = 0.98;
Phi = 200;
Epsilon = -0.1;
k = 1.6;

Sigma = 0.8;

M1A_H1=Xdog2(A_H,Gamma,Phi,Epsilon,k,Sigma);
M1B_H1=Xdog2(B_H,Gamma,Phi,Epsilon,k,Sigma);

MB_H1=M1A_H1>M1B_H1;
MA_H1=M1B_H1>M1A_H1;

%% Decision map of detail layers
w=9;
M2A_H=SF(A_H,w).*local_energy(A_H,w);
M2B_H=SF(B_H,w).*local_energy(B_H,w);

 
 
map1=(abs(M2A_H)>abs(M2B_H));
map2=(abs(M2B_H)>abs(M2A_H));

for i=1:row
    for  j=1:column 
      if M1B_H1(i,j)>M1A_H1(i,j)
           map1(i,j)=MA_H1(i,j);
    end
    end 
end
 
 for i=1:row
 for  j=1:column 
      if M1A_H1(i,j)>M1B_H1(i,j)
           map2(i,j)=MB_H1(i,j);
    end
 end 
 end


%% FGF
r=4;

eps = 0.02^2;
S=4;
MA_H_guide=fastguidedfilter(A, map1, r, eps,S);
MB_H_guide=fastguidedfilter(B, map2, r, eps,S);


H_F1= A_H.*MA_H_guide+B_H.*MB_H_guide;

  

F=F1_L+H_F1;


%% YUV to RGB
F_YUV=zeros(hei,wid,3);
F_YUV(:,:,1)=F;
F_YUV(:,:,2)=B_YUV(:,:,2);
F_YUV(:,:,3)=B_YUV(:,:,3);
final_F=ConvertYUVtoRGB(F_YUV);    
toc
figure,imshow(final_F,'border','tight');
final_fuse=uint8(final_F*255);





