%% 1KM

clear
lat_lon=xlsread('E:\temp\Syria_sample\Results\Lable\for_DistanceCalculate\raster_lat_lon.xlsx');
maskpath='E:\temp\Syria_sample\Results\Lable\for_DistanceCalculate\NightLightChange9811_1219_ls20.tif';
[mask,geo]=geotiffread(maskpath);
info=geotiffinfo(maskpath);
lat=lat_lon(:,4);
lon=lat_lon(:,5);
Conflict_zone=mask==1;
Con_OBJECTID=find(Conflict_zone');    %%arcgis按行走的ID，matlab按列搜的ID，这里转置，使matlab搜索的ID与arcgis Id对应
%冲突区域的经纬度
Conflict_zone_lat=lat(Con_OBJECTID);
Conflict_zone_lon=lon(Con_OBJECTID);

%%背景区域的经纬度
other_area=mask==0;
Other_OBJECTID=find(other_area');
Other_lat=lat(Other_OBJECTID);
Other_lon=lon(Other_OBJECTID);

%%暴力法搜索最短距离
min_dis=zeros(length(Other_OBJECTID),1);

for i=1:length(Other_OBJECTID)
    tmp=zeros(length(Con_OBJECTID) ,1);
   for j=1:length(Con_OBJECTID) 
     tmp(j)=latlon2Dis(Other_lat(i),Other_lon(i),Conflict_zone_lat(j),Conflict_zone_lon(j));
   end  
     min_dis(i)=min(tmp);
end

[m,n]=size(mask');
Dismap=zeros(m,n);
Dismap(Other_OBJECTID)=min_dis;
Dismap(Con_OBJECTID)=0;
Dismap=Dismap';
Dismap(isnan(mask))=nan;
geotiffwrite('E:\temp\Syria_sample\Results\Lable\for_DistanceCalculate\NightLightChange9811_1219_ls20_dis.tif', Dismap, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);











%% 25KM




clear
lat_lon=xlsread('E:\temp\Syria_sample\Results\Lable\for_DistanceCalculate\raster_lat_lon_25km.xlsx');
maskpath='E:\temp\Syria_sample\Results\Lable\for_DistanceCalculate\NightLightChange9811_1219_25KM_ls10000.tif';
[mask,geo]=geotiffread(maskpath);
info=geotiffinfo(maskpath);
lat=lat_lon(:,4);
lon=lat_lon(:,5);
Conflict_zone=mask==1;
Con_OBJECTID=find(Conflict_zone');    %%arcgis按行走的ID，matlab按列搜的ID，这里转置，使matlab搜索的ID与arcgis Id对应
%冲突区域的经纬度
Conflict_zone_lat=lat(Con_OBJECTID);
Conflict_zone_lon=lon(Con_OBJECTID);

%%背景区域的经纬度
other_area=mask==0;
Other_OBJECTID=find(other_area');
Other_lat=lat(Other_OBJECTID);
Other_lon=lon(Other_OBJECTID);

%%暴力法搜索最短距离
min_dis=zeros(length(Other_OBJECTID),1);

for i=1:length(Other_OBJECTID)
    tmp=zeros(length(Con_OBJECTID) ,1);
   for j=1:length(Con_OBJECTID) 
     tmp(j)=latlon2Dis(Other_lat(i),Other_lon(i),Conflict_zone_lat(j),Conflict_zone_lon(j));
   end  
     min_dis(i)=min(tmp);
end

[m,n]=size(mask');
Dismap=zeros(m,n);
Dismap(Other_OBJECTID)=min_dis;
Dismap(Con_OBJECTID)=0;
Dismap=Dismap';
Dismap(isnan(mask))=nan;
geotiffwrite('E:\temp\Syria_sample\Results\Lable\for_DistanceCalculate\NightLightChange9811_1219_25KM_ls10000_dis.tif', Dismap, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
