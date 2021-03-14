import numpy as np
import os
import gdal
from sklearn.ensemble import RandomForestClassifier
import joblib





def write_geotiff(fname, data, geo_transform, projection):
    """Create a Geotiff file with given data."""
    driver = gdal.GetDriverByName('Gtiff')
    ##gdal.GetDriverByName('ENVI')
    ##destination = driver.Create("test.bsq", ncols, nrows, 1, gdal.GDT_Byte)
    rows, cols = data.shape
    dataset = driver.Create(fname, cols, rows, 1, gdal.GDT_Byte)
    dataset.SetGeoTransform(geo_transform)
    dataset.SetProjection(projection)
    band = dataset.GetRasterBand(1)
    band.WriteArray(data)
    dataset = None
    ##close




year_start = 2009


year_end = year_start+1

for year in range(year_start, year_end):
    raster_data_path ='/lustre/scratch/xiyali/Translate/{}mosaic.tif'.format(year)
    output_fname = '/lustre/work/xiyali/'+os.path.basename(raster_data_path).split(".")[0]+'_Classfication_loop16.tif'
    print('input',raster_data_path)
    print('output',output_fname)



    raster_dataset = gdal.Open(raster_data_path, gdal.GA_ReadOnly)
    geo_transform = raster_dataset.GetGeoTransform()
    proj = raster_dataset.GetProjectionRef()
    bands_data=[]
    for b in range(1,raster_dataset.RasterCount+1):
        band = raster_dataset.GetRasterBand(b)
        bands_data.append(band.ReadAsArray())

    bands_data = np.dstack(bands_data)   ## arrage data in depth(band dimension)
    rows, cols, n_bands = bands_data.shape

    mask  = (-20000<=bands_data) &( bands_data<=20000)
    mask = np.logical_not(mask)
    bands_data[mask]=0

    print('image read completed')
    classifier = joblib.load('/home/xiyali/classfication/train_model.m')

    bands_data = bands_data.astype(np.int16)


    n_samples = rows*cols
    flat_pixels = bands_data.reshape(n_samples, n_bands)
    flat_pixels = flat_pixels.astype(np.int16)
    del bands_data

    result1 = classifier.predict(flat_pixels[0:int(len(flat_pixels)/16)])
    print('1 sucecess')
    for i in range(2,17):
        tmp = classifier.predict(flat_pixels[(i-1)*int(len(flat_pixels)/16):i*int(len(flat_pixels)/16)].astype(np.int16))
        result1 = np.hstack((result1,tmp))
        print(str(i)+'sucecess')

    tmp = classifier.predict(flat_pixels[i*int(len(flat_pixels)/16):len(flat_pixels)].astype(np.int16))
    del flat_pixels
    result1 = np.hstack((result1,tmp))
    result1 = result1.reshape((rows, cols))   ##results


    ##write the results

    result1 = 1-result1
    write_geotiff(output_fname, result1, geo_transform, proj)

