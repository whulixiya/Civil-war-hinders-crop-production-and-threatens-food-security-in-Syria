## Figure 3 

import gdal
import numpy as np

from matplotlib.colors import LogNorm
from pylab import *
from scipy.stats.mstats import winsorize

Crop = gdal.Open('E:/temp/Syria_sample/Panel_source_data/25KM/Syria_Crop98_19_25KM_areaCoe.tif')

Crop_data=[]
for b in range(1,Crop.RasterCount+1):
    band = Crop.GetRasterBand(b)
    Crop_data.append(band.ReadAsArray())

Crop_data = np.dstack(Crop_data)   ## arrage data in depth(band dimension)



mask = gdal.Open('E:/temp/Syria_sample/Panel_source_data/25KM/Syria_Crop_lt50_mask_25KM.tif')

mask_data=[]
for b in range(1,mask.RasterCount+1):
    band = mask.GetRasterBand(b)
    mask_data.append(band.ReadAsArray())

mask_data = np.dstack(mask_data)   ## arrage data in depth(band dimension)



DIS = gdal.Open('E:/temp/Syria_sample/Results/Lable/for_DistanceCalculate/NightLightChange9811_1219_25KM_ls10000_dis.tif')

DIS_data=[]
for b in range(1,DIS.RasterCount+1):
    band = DIS.GetRasterBand(b)
    DIS_data.append(band.ReadAsArray())






DIS_data = np.dstack(DIS_data)   ## arrage data in depth(band dimension)
Crop_data=Crop_data.astype(np.float32)

DIS_data=np.reshape(DIS_data,(24,30))




mask_data=1-mask_data
mask_data=np.repeat(mask_data, 22, axis=2)
mask_data=mask_data>0;



Crop_data[mask_data]=NaN;
Crop_data=Crop_data/10000   ##m2 to ha



Crop_data_before=mean(Crop_data[:,:,0:14],2);
Crop_data_change=mean(Crop_data[:,:,14:22],2)-Crop_data_before;


Crop_stat_change_2012=Crop_data[:,:,14]-Crop_data_before;
Crop_stat_change_2013=Crop_data[:,:,15]-Crop_data_before;
Crop_stat_change_2014=Crop_data[:,:,16]-Crop_data_before;
Crop_stat_change_2015=Crop_data[:,:,17]-Crop_data_before;
Crop_stat_change_2016=Crop_data[:,:,18]-Crop_data_before;
Crop_stat_change_2017=Crop_data[:,:,19]-Crop_data_before;
Crop_stat_change_2018=Crop_data[:,:,20]-Crop_data_before;
Crop_stat_change_2019=Crop_data[:,:,21]-Crop_data_before;


def DrawScatterDensity(x,y,t):
    plt.figure(figsize=(6.25, 5))
    x=x[~np.isnan(x)].flatten()
    y=y[~np.isnan(y)].flatten()    
    hist2d(x, y, bins=50, norm=LogNorm())
    parameter = np.polyfit(x, y, 1)
    y2 = parameter[0] * x  + parameter[1]
    p = np.poly1d(parameter)
    plt.plot(x, p(x), color='r')
    plt.legend(['$\mathregular{R^2}$'+'= '+str( round(np.corrcoef(y, p(x))[0,1]**2,2))])  
    font = {'family' : 'Times New Roman',
    'weight' : 'normal',
    'size'   : 12,}
    #'size'   : 8,}
    plt.xlabel('Distance',font)
    plt.ylabel('Cropland Area Change(ha)',font)   
    plt.title(str(t),font)
    ax = plt.gca() 
    ax.yaxis.get_major_formatter().set_powerlimits((0,1))
    colorbar()
    show()



mask_nan_dis=np.isnan(DIS_data) | np.isnan(Crop_data_change) 
mask_nan_dis=mask_nan_dis | (Crop_data_change==0)



Crop_data_change=winsorize(Crop_data_change,limits=[0.05,0.05])   ##The outliers were handled by winsorizing with the threshold of 5%. https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.mstats.winsorize.html
DrawScatterDensity(DIS_data[~mask_nan_dis],Crop_data_change[~mask_nan_dis],'Wartime(2012-2019)')

Crop_stat_change_2012=winsorize(Crop_stat_change_2012,limits=[0.05,0.05])
Crop_stat_change_2013=winsorize(Crop_stat_change_2013,limits=[0.05,0.05])
Crop_stat_change_2014=winsorize(Crop_stat_change_2014,limits=[0.05,0.05])
Crop_stat_change_2015=winsorize(Crop_stat_change_2015,limits=[0.05,0.05])
Crop_stat_change_2016=winsorize(Crop_stat_change_2016,limits=[0.05,0.05])
Crop_stat_change_2017=winsorize(Crop_stat_change_2017,limits=[0.05,0.05])
Crop_stat_change_2018=winsorize(Crop_stat_change_2018,limits=[0.05,0.05])
Crop_stat_change_2019=winsorize(Crop_stat_change_2019,limits=[0.05,0.05])

DrawScatterDensity(DIS_data[~mask_nan_dis],Crop_stat_change_2012[~mask_nan_dis],'2012')
DrawScatterDensity(DIS_data[~mask_nan_dis],Crop_stat_change_2013[~mask_nan_dis],'2013')
DrawScatterDensity(DIS_data[~mask_nan_dis],Crop_stat_change_2014[~mask_nan_dis],'2014')
DrawScatterDensity(DIS_data[~mask_nan_dis],Crop_stat_change_2015[~mask_nan_dis],'2015')
DrawScatterDensity(DIS_data[~mask_nan_dis],Crop_stat_change_2016[~mask_nan_dis],'2016')
DrawScatterDensity(DIS_data[~mask_nan_dis],Crop_stat_change_2017[~mask_nan_dis],'2017')
DrawScatterDensity(DIS_data[~mask_nan_dis],Crop_stat_change_2018[~mask_nan_dis],'2018')
DrawScatterDensity(DIS_data[~mask_nan_dis],Crop_stat_change_2019[~mask_nan_dis],'2019')





##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/wartime.txt', Crop_data_change[~mask_nan_dis], fmt='%s', delimiter=' ')
##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/2012.txt', Crop_stat_change_2012[~mask_nan_dis], fmt='%s', delimiter=' ')
##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/2013.txt', Crop_stat_change_2013[~mask_nan_dis], fmt='%s', delimiter=' ')
##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/2014.txt', Crop_stat_change_2014[~mask_nan_dis], fmt='%s', delimiter=' ')
##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/2015.txt', Crop_stat_change_2015[~mask_nan_dis], fmt='%s', delimiter=' ')
##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/2016.txt', Crop_stat_change_2016[~mask_nan_dis], fmt='%s', delimiter=' ')
##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/2017.txt', Crop_stat_change_2017[~mask_nan_dis], fmt='%s', delimiter=' ')
##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/2018.txt', Crop_stat_change_2018[~mask_nan_dis], fmt='%s', delimiter=' ')
##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/2019.txt', Crop_stat_change_2019[~mask_nan_dis], fmt='%s', delimiter=' ')
##np.savetxt('E:/temp/Syria_sample/Results/Fishnet_25KM/Crop_dis/Dis.txt', DIS_data[~mask_nan_dis], fmt='%s', delimiter=' ')




