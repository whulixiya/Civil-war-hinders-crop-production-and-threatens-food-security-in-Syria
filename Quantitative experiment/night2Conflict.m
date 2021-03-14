Nightfile='E:\temp\Syria_sample\Results\Lable\NightLightChange1219_9811_NoOilFiled.tif';
[Night,R]=geotiffread(Nightfile); 
info=geotiffinfo(Nightfile);
night=Night;
night(night>-20)=0;
night(night<=-20)=1;
%%mask=isnan(night);
%night(isnan(night))=0;  %%长宽不一样
%[D,IDX] = bwdist(night);
%D(mask)=NaN;
geotiffwrite('E:\temp\Syria_sample\Results\Lable\for_DistanceCalculate\NightLightChange9811_1219_ls20.tif',night, R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag); 
% clear
% [Night,R]=geotiffread('E:\temp\Syria_sample\Panel_source_data\1KM\DMSP_VIIRS_Syria_Only0008333345.tif');   
% info=geotiffinfo('E:\temp\Syria_sample\Panel_source_data\1KM\DMSP_VIIRS_Syria_Only0008333345.tif');
% Night=Night(:,:,7:28);
% Night_before=mean(Night(:,:,1:14),3);
% mask=isnan(Night);
% 
% 
% Night=Night-repmat(Night_before,1,1,22);
% Night(Night>-20)=0;
% Night(Night<=-20)=1;
% Night(:,:,1:14)=0;
% 
% Night(isnan(Night))=0;
% [D,IDX] = bwdist(Night);
% D(:,:,1:14)=NaN;
% D(mask)=NaN;
% D(:,:,15:22)=D(:,:,15:22);
% geotiffwrite('E:\temp\Syria_sample\Results\Lable\NightLightChange9811_1219_ls20_disPeryear.tif', D, R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag); 
% 

%%25KM

Nightfile='E:\temp\Syria_sample\Panel_source_data\25KM\DMSP_VIIRS_Syria_NoOilFiled_25KM.tif';
[Night,R]=geotiffread(Nightfile); 
info=geotiffinfo(Nightfile);
prewar=mean(Night(:,:,7:20),3);
wartime=mean(Night(:,:,21:28),3);
night=wartime-prewar;
night(night>-10000)=0;
night(night<=-10000)=1;
% mask=isnan(night);
% night(isnan(night))=0;

%[D,IDX] = bwdist(night);
%D(mask)=NaN;

geotiffwrite('E:\temp\Syria_sample\Results\Lable\for_DistanceCalculate\NightLightChange9811_1219_25KM_ls10000.tif', night, R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag); 

% 
% % 
% clear
% [Night,R]=geotiffread('E:/temp/Syria_sample/Panel_source_data/25KM/DMSP_VIIRS_Syria_NoOilFiled_25KM.tif');   
% info=geotiffinfo('E:/temp/Syria_sample/Panel_source_data/25KM/DMSP_VIIRS_Syria_NoOilFiled_25KM.tif');
% Night=Night(:,:,7:28);
% Night_before=mean(Night(:,:,1:14),3);
% mask=isnan(Night(:,:,15:22));
% 
% 
% Night=Night-repmat(Night_before,1,1,22);
% results=zeros(24,30,8);
% for i=15:22
%     tmp=Night(:,:,i);
%     tmp(tmp>min(tmp(:))*0.7)=0;
%     tmp(tmp<min(tmp(:))*0.7)=1;
%     results(:,:,i-14)=tmp;
% end
% 
% 
% results(mask)=0;
% [D,IDX] = bwdist(results);
% 
% D(mask)=NaN;
% 
% geotiffwrite('E:\temp\Syria_sample\Results\Lable\NightLightChange9811_1219_25KM_ls8000_dis_peryear.tif', D, R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag); 
% 
