function ERGAS=ergas(imagery1,imagery2)
dim=size(imagery1);
ergas=zeros(1,dim(4));
for i=1:dim(4)
ergas(i) = ErrRelGlobAdimSyn(imagery1(:,:,:,i), imagery2(:,:,:,i));
end
ERGAS=mean(ergas);