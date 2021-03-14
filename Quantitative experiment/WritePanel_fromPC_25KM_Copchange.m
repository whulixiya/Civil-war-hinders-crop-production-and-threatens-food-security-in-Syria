clear

[mask,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\25KM\Syria_Crop_lt50_mask_25KM.tif');   
[Crop,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\25KM\Syria_Crop98_19_25KM_areaCoe.tif');   
Crop=Crop(:,:,1:22);  %%1998-2019
[Night,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\25KM\DMSP_VIIRS_Syria_NoOilFiled_25KM.tif');   
Night=Night(:,:,7:28);
[CDR,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\25KM\CDR_sum_9819_25KM.tif');   

mask=logical(mask);

OBJECTID=find(mask);  %get index
numyear=22;
mask=repmat(mask,1,1,numyear);
length=sum(mask(:));
Crop=double(Crop);
Crop_before_mean=mean(Crop(:,:,1:14),3);
Crop=Crop-repmat(Crop_before_mean,1,1,22);
Crop(:,:,1:14)=NaN;

Crop_stat=reshape(Crop(mask),length/numyear,numyear);
Crop_stat=reshape(Crop_stat',length,1);

Crop_stat=double(Crop_stat)/10000;

Night=double(Night);
Night_before_mean=mean(Night(:,:,1:14),3);
Night=Night-repmat(Night_before_mean,1,1,22);

Night(isnan(Night))=0;
Night(:,:,1:14)=NaN;
Night_stat=reshape(Night(mask),length/numyear,numyear);
Night_stat=reshape(Night_stat',length,1);




CDR_before_mean=mean(CDR(:,:,1:14),3);
CDR=CDR-repmat(CDR_before_mean,1,1,22);


CDR(:,:,1:14)=NaN;
CDR_stat=reshape(CDR(mask),length/numyear,numyear);
CDR_stat=reshape(CDR_stat',length,1);



Fishnet_num=length/numyear;
yearStart=1998;
yearEnd=2019;
Yearlen=yearEnd-yearStart+1;

%% write csv
A=cell(Fishnet_num*Yearlen+1,5);
A{1,1} = 'INDEX';
A{1,2} = 'year';
A{1,3}='Crop_change';
A{1,4}='Night_change';
A{1,5}='CDR_change';

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
        A{K,2}=j;   
    end
end




A(2:end,3)=num2cell(Crop_stat(:));  %%CROP

A(2:end,4)=num2cell(Night_stat(:));  %%Night
A(2:end,5)=num2cell(CDR_stat(:));  %%Night



%%xlswrite('E:\temp\Syria_sample\Results\panel_data.xlsx',A);
%%file too long

%%write as txt
fileID = fopen('E:\temp\Syria_sample\Results\Fishnet_25KM\panel_data_9819_Crop_change.txt','w');

formatSpec = '%s %s %s %s %s\n';  %1st line
fprintf(fileID,formatSpec,A{1,:});
%%2 to end 
formatSpec = '%d %d %20.10f %20.10f %20.10f\n';
[nrows,ncols] = size(A);
for row = 2:nrows
    fprintf(fileID,formatSpec,A{row,:});
end

fclose(fileID);










