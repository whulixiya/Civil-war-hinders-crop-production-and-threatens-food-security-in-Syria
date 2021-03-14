clear
Cropfile='E:\temp\Syria_sample\Panel_source_data\1KM\Syria_Crop98_19_1KM_areaCoe.tif';
[Crop,R]=geotiffread(Cropfile); 
Crop=double(Crop)/10000;
[m,n,z]=size(Crop);
info=geotiffinfo(Cropfile);


%%PRE
fpath ='E:\temp\Syria_sample\Results\Fishnet_1KM\Predict-cdr\cropf.txt';  %这里是文件夹的名字
fid=fopen(fpath);
[num_Crop_pre] =  textscan(fid,'%s','delimiter',',');
fclose(fid);
num_Crop_pre=num_Crop_pre{1};
num_Crop_pre=num_Crop_pre(2:end);
num_Crop_pre=str2double(num_Crop_pre);

[mask,~]=geotiffread('E:\temp\Syria_sample\Panel_source_data\1KM\Syria_Crop_lt50_mask_1KM.tif');   
mask=logical(mask);
OBJECTID=find(mask);  %get index

results=0;

test=[];
for i =15:22
Crop_ob_tmp=Crop(:,:,i);
num_Crop_pre_tmp=num_Crop_pre(i:22:length(num_Crop_pre));
Crop_pre_tmp=zeros(m,n);
     for j=1:length(OBJECTID)
        Crop_pre_tmp(OBJECTID(j))=num_Crop_pre_tmp(j);
     end
Crop_pre_ob_diff_tmp=(Crop_pre_tmp-double(Crop_ob_tmp));
results=results+Crop_pre_ob_diff_tmp;
outname=strcat('E:\temp\Syria_sample\Results\Fishnet_1KM\Model_predict\Crop_pre_ob_diff',num2str(i-15+2012));
outname=strcat(outname,'_EW.tif');

%geotiffwrite(outname, Crop_pre_ob_diff_tmp, R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag); 
end
geotiffwrite('E:\temp\Syria_sample\Results\Fishnet_1KM\Model_predict\Crop_ob_pre_mean_EW.tif', round(-results/8), R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag); 
