function cp=local_energy(matrix,N)
[row,column]=size(matrix);
matrix_en=abs(padarray(matrix,[N N],'symmetric'));   
for i=1:row
    for j=1:column
        window=abs(matrix_en(i:1:(i+2*N),j:1:(j+2*N)));
        cp(i,j)=sum(window(:));
    end
end


