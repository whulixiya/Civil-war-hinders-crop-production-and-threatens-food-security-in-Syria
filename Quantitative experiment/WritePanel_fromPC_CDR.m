clear

[mask,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\1KM\Syria_Crop_lt50_mask_1KM.tif');   
[Crop,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\1KM\Syria_Crop98_19_1KM_areaCoe.tif');   
Crop=Crop(:,:,1:22);  %%1998-2018
[Night,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\1KM\DMSP_VIIRS_Syria_NoOilFiled');   
Night=Night(:,:,7:28);
[CDR,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\1KM\CDR_sum_9819_1KM.tif');   

mask=logical(mask);

OBJECTID=find(mask);  %get index

yearlen=22;
mask=repmat(mask,1,1,yearlen);
length=sum(mask(:));

Crop_stat=reshape(Crop(mask),length/yearlen,yearlen);
Crop_stat=reshape(Crop_stat',length,1);

Crop_before=mean(Crop(:,:,1:14),3);
Crop_stat_change=double(Crop);
Crop_stat_change(:,:,1:14)=NaN;
Crop_stat_change(:,:,15:22)=double(Crop_stat_change(:,:,15:22))-repmat(Crop_before,1,1,8);
Crop_stat_change=reshape(Crop_stat_change(mask),length/yearlen,yearlen);
Crop_stat_change=reshape(Crop_stat_change',length,1);




Night_stat=reshape(Night(mask),length/yearlen,yearlen);
%%post -pre 
[mask_pre,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\1KM\Syria_Crop_lt50_mask_1KM.tif');   
[Night_pre,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\1KM\DMSP_VIIRS_Syria_NoOilFiled');   
Night_pre=Night_pre(:,:,7:19);
mask_pre=logical(mask_pre);
mask_pre=repmat(mask_pre,1,1,13);
length_pre=sum(mask_pre(:));
Night_pre=reshape(Night_pre(mask_pre),length_pre/13,13);
Night_pre_mean=mean(Night_pre,2);
Night_pre_mean=repmat(Night_pre_mean,1,9,1);
[tmp_m,tmp_n]=size(Night_stat);
tmp=zeros(tmp_m,tmp_n);
tmp(tmp==0)=nan;
tmp(:,14:22)=Night_pre_mean;
Night_stat_diff=Night_stat-tmp;
%%


Night_stat=reshape(Night_stat',length,1);
Night_stat_diff=reshape(Night_stat_diff',length,1);


CDR_stat=reshape(CDR(mask),length/yearlen,yearlen);
CDR_stat=reshape(CDR_stat',length,1);



[DIS,~]=geotiffread('E:\temp\Syria_sample\Results\Lable\for_DistanceCalculate\NightLightChange9811_1219_ls20_dis.tif');
DIS=repmat(DIS,1,1,yearlen);
DIS_stat=reshape(DIS(mask),length/yearlen,yearlen);
DIS_stat=reshape(DIS_stat',length,1);

% [DIS,~]=geotiffread('E:\temp\Syria_sample\Results\Lable\NightLightChange9811_1219_ls20_disPeryear.tif');   
% %DIS=repmat(DIS,1,1,yearlen);
% DIS_stat=reshape(DIS(mask),length/yearlen,yearlen);
% DIS_stat=reshape(DIS_stat',length,1);



Fishnet_num=length/yearlen;
yearStart=1998;
yearEnd=2019;
Yearlen=yearEnd-yearStart+1;

%% write csv
A=cell(Fishnet_num*Yearlen+1,10);
A{1,1} = 'INDEX';
A{1,2} = 'year';
A{1,3}='CDR';
A{1,4}='Crop';
A{1,5}='NightLight';
A{1,6}='Warnode';
A{1,7}='Night_CDR';
A{1,8}='Night_Post-pre';
A{1,9}='min_DIS2war';
A{1,10}='Crop_stat_change';

K=1;
for i =1:Fishnet_num
    for j=yearStart:yearEnd
        K=K+1;
        A{K,1}=OBJECTID(i);   %%ID第一列
    end
end

K=1;
for i =1:Fishnet_num
    for j=yearStart:yearEnd
        K=K+1;
        A{K,2}=j;   %%年份第二列
    end
end





A(2:end,3)=num2cell(CDR_stat(:));  %%CDR
Crop_stat=double(Crop_stat)/10000;
A(2:end,4)=num2cell(Crop_stat(:));  %%CROP
Night_stat(isnan(Night_stat))=0;
A(2:end,5)=num2cell(Night_stat(:));  %%Night
A(2:end,9)=num2cell(DIS_stat(:));  %%Distance
A(2:end,10)=num2cell(Crop_stat_change(:));

K=1;
for i =1:Fishnet_num
    for j=yearStart:yearEnd
        K=K+1;
        war_index=j>2011;
        A{K,6}=war_index;   %%war node第6列
    end
end

NC=Night_stat.*CDR_stat;
A(2:end,7)=num2cell(NC(:));  %%Night*CROP

A(2:end,8)=num2cell(Night_stat_diff(:));








%%xlswrite('E:\temp\Syria_sample\Results\panel_data.xlsx',A);
%%file too long

%%write as txt
fileID = fopen('E:\temp\Syria_sample\Results\Fishnet_1KM\panel_data_9819_cdr.txt','w');

formatSpec = '%s %s %s %s %s %s %s %s %s %s\n';  %1st line
fprintf(fileID,formatSpec,A{1,:});
%%2 to end 
formatSpec = '%d %d %20.10f %20.10f %20.10f %d %10.4f %20.4f %20.10f %20.10f\n';
[nrows,ncols] = size(A);
for row = 2:nrows
    fprintf(fileID,formatSpec,A{row,:});
end

fclose(fileID);
































