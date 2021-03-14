clear

[mask,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\25KM\Syria_Crop_lt50_mask_25KM.tif');   
[Crop,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\25KM\Syria_Crop98_19_25KM.tif');   
Crop=Crop(:,:,1:22);  %%1998-2019
[CDR,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\25KM\CDR_sum_9819_25KM.tif');   

mask=logical(mask);

OBJECTID=find(mask);  %get index
numyear=22;
mask=repmat(mask,1,1,numyear);
length=sum(mask(:));

Crop_stat=reshape(Crop(mask),length/numyear,numyear);
Crop_stat=reshape(Crop_stat',length,1);



CDR_stat=reshape(CDR(mask),length/numyear,numyear);
CDR_stat=reshape(CDR_stat',length,1);


Fishnet_num=length/numyear;
yearStart=1998;
yearEnd=2019;
Yearlen=yearEnd-yearStart+1;

%% write csv
A=cell(Fishnet_num*Yearlen+1,4);
A{1,1} = 'INDEX';
A{1,2} = 'year';
A{1,3}='CDR';
A{1,4}='Crop';



K=1;

for i =1:Fishnet_num
    for j=yearStart:yearEnd
        K=K+1;
        A{K,1}=OBJECTID(i);   %%ID第一�?
    end
end

K=1;
for i =1:Fishnet_num
    for j=yearStart:yearEnd
        K=K+1;
        A{K,2}=j;   %%年份第二�?
    end
end





A(2:end,3)=num2cell(CDR_stat(:));  %%CDR

A(2:end,4)=num2cell(Crop_stat(:));  %%CROP



%%xlswrite('E:\temp\Syria_sample\Results\panel_data.xlsx',A);
%%file too long

%%write as txt
fileID = fopen('E:\temp\Syria_sample\Results\Fishnet_25KM\panel_data_9819_cdr.txt','w');

formatSpec = '%s %s %s %s\n';  %1st line
fprintf(fileID,formatSpec,A{1,:});
%%2 to end 
formatSpec = '%d %d %20.10f %20.10f\n';
[nrows,ncols] = size(A);
for row = 2:nrows
    fprintf(fileID,formatSpec,A{row,:});
end

fclose(fileID);










