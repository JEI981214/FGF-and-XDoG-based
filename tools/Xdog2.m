function F= Xdog(inputIm,Gamma,Phi,Epsilon,k,Sigma)
%XDOG 此处显示有关此函数的摘要
%   此处显示详细说明


if size(inputIm,3)>1
    inputIm=rgb2gray(inputIm);             % A 是灰度图
end
%inputIm = rgb2gray(inputIm);
inputIm = im2double(inputIm);

% Gauss Filters
gFilteredIm1 = imgaussfilt(inputIm, Sigma);
gFilteredIm2 = imgaussfilt(inputIm, Sigma * k);

differencedIm2 = gFilteredIm1 - (Gamma * gFilteredIm2);

x = size(differencedIm2,1);
y = size(differencedIm2,2);

% Extended difference of gaussians
for i=1:x
    for j=1:y
        if differencedIm2(i, j) < Epsilon
            differencedIm2(i, j) = 1;
        else
            differencedIm2(i, j) = 1 + tanh(Phi*(differencedIm2(i,j)));
        end
    end
end


 F =differencedIm2;
