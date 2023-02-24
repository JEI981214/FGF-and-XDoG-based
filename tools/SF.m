function cp=SF(matrix,w)
% Compute the spatial frequency (SF) of image or subbbands of NSCT.
% ---------
% Author:  Qu Xiao-Bo    <quxiaobo <at> xmu.edu.cn or qxb_xmu@yahoo.com.cn>    Aug.28,2008
%          Postal address:
% Room 509, Scientific Research Building # 2,Haiyun Campus, Xiamen University,Xiamen,Fujian, P. R. China, 361005
% Website: http://quxiaobo.8866.org or http://quxiaobo.go.8866.org
%=============================================================
% disp('SF is computing...')
[row,column]=size(matrix);
cp=zeros(row,column);
window_wide=w;
spread=(window_wide-1)/2;
matrix_en=padarray(matrix,[spread spread],'symmetric');
temp=matrix_en.*0;
for i=1:row
    for j=1:column
        temp(i,j)=((matrix_en(i+1,j+1)-matrix_en(i+1,j))^2+(matrix_en(i+1,j+1)-matrix_en(i,j+1))^2);
    end
end
for i=1:row
    for j=1:column
        window=temp(i:1:(i+2*spread),j:1:(j+2*spread));
        cp(i,j)=sqrt(sum(window(:))./(window_wide.^2));
    end
end