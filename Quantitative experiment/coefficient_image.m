close all;
clear;
clc;
%% 30 m
data=xlsread('E:\temp\Syria_sample\Results\trapezoid\ДњТы\trapezoid_areas_0.00026949459.xlsx');

[coef,geo]=geotiffread('E:\temp\Syria_sample\Results\trapezoid\Constant.tif');
info=geotiffinfo('E:\temp\Syria_sample\Results\trapezoid\Constant.tif');
coef=single(coef);

row = 18924;
for i=1:row
    coef(row+1-i,:)=data(i,2);
end

geotiffwrite('E:\temp\Syria_sample\Results\trapezoid\WGS_area.tif', coef, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);

%% 1km
clear
data=xlsread('E:\temp\Syria_sample\Results\trapezoid\ДњТы\trapezoid_areas_0.008333345.xlsx');

[coef,geo]=geotiffread('E:\temp\Syria_sample\Results\trapezoid\Constant_1KM.tif');
info=geotiffinfo('E:\temp\Syria_sample\Results\trapezoid\Constant_1KM.tif');
coef=single(coef);

row = 602;
for i=1:row
    coef(row+1-i,:)=data(i,2);
end

geotiffwrite('E:\temp\Syria_sample\Results\trapezoid\WGS_area_1km.tif', coef, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);

%% 25KM
clear
data=xlsread('E:\temp\Syria_sample\Results\trapezoid\ДњТы\trapezoid_areas_0.22457882.xlsx');

[coef,geo]=geotiffread('E:\temp\Syria_sample\Results\trapezoid\Constant_25KM.tif');
info=geotiffinfo('E:\temp\Syria_sample\Results\trapezoid\Constant_25KM.tif');
coef=single(coef);

row = 27;
for i=1:row
    coef(row+1-i,:)=data(i,2);
end

geotiffwrite('E:\temp\Syria_sample\Results\trapezoid\WGS_area_25km.tif', coef, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);