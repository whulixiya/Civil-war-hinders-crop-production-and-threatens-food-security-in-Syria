var aoi = ee.FeatureCollection('users/whulixiya/Syria').geometry(); // s


//var startYear_list = [2002, 2007, 2012, 2018]
var startYear  = 2018;    // define year



// define function to calculate a spectral index to segment with LT
// define function to calculate a spectral index to segment with LT
var GetIndex = function(img) {
    var index1 = img.normalizedDifference(['B4', 'B3'])                      // calculate NDVI
                   .multiply(1000)                                          // ...scale results by 1000 so we can convert to int and retain some precision
                   .select([0], ['NDVI'])                                    // ...name the band
    
    var mask = index1.lt(1000)
    index1 = index1.updateMask(mask)
    var index2 = img.normalizedDifference(['B2', 'B4'])                      // calculate NDWI
                   .multiply(1000)                                          // ...scale results by 1000 so we can convert to int and retain some precision
                   .select([0], ['NDWI'])   
   
   
   
    return index1.addBands(index2) ;
};





var harmonizationRoy = function(oli) {
  var y = oli.select(['B2','B3','B4','B5','B6','B10','B7'],['B1', 'B2', 'B3', 'B4', 'B5','B6' ,'B7']) // select OLI bands 2-7 and rename them to match L7 band names           
             .set('system:time_start', oli.get('system:time_start'));                      // ...set the output system:time_start metadata to the input image time_start otherwise it is null
  return y;                                                                      
};

var getSRcollection = function(year, start_month, end_month, sensor, aoi) {
    var start_month_tmp = ee.Number.parse(start_month[0]+start_month[1])
    var end_month_tmp = ee.Number.parse(end_month[0]+end_month[1])
    var year_start=ee.Algorithms.If(end_month_tmp.subtract(start_month_tmp).lt(0),year-1,year)  //judge if transyear
 
  var srCollection = ee.ImageCollection('LANDSAT/'+ sensor + '/C01/T1_SR') 
                       .filterBounds(aoi)                                  
                       .filterDate(ee.String(year_start).cat('-').cat(start_month), year+'-'+end_month)
                    //  .filter(ee.Filter.lt('CLOUD_COVER', 60));
  print(srCollection)
       
  srCollection = srCollection.map(function(img) {
    var dat = ee.Image(
      ee.Algorithms.If(
        sensor == 'LC08',                                                  // condition - if image is OLI
        harmonizationRoy(img),                                          //true
        img.select(['B1', 'B2', 'B3', 'B4', 'B5', 'B6','B7'])                   // false - else select out the reflectance bands from the non-OLI image
           .set('system:time_start', img.get('system:time_start'))         // ...set the output system:time_start metadata to the input image time_start otherwise it is null
      )
    );
    
    // make a cloud, cloud shadow, and snow mask from fmask band
    var qa = img.select('pixel_qa');                                       // select out the fmask band
    var mask = qa.bitwiseAnd(8).eq(0).and(                                 // include shadow
               qa.bitwiseAnd(16).eq(0)).and(                               // include snow
               qa.bitwiseAnd(32).eq(0));                                   // include clouds
    
    // apply the mask to the image and return it
    return dat.mask(mask);
  });

  return srCollection; // return the prepared collection
};




var getCombinedSRcollection = function(year, start_month, end_month, aoi) {


    var lt5 = getSRcollection(year, start_month, end_month, 'LT05', aoi);       // get TM collection for a given year, date range, and area
    var le7 = getSRcollection(year, start_month, end_month, 'LE07', aoi);       // get ETM+ collection for a given year, date range, and area
    var lc8 = getSRcollection(year, start_month, end_month, 'LC08', aoi);       // get OLI collection for a given year, date range, and area
    var mergedCollection = ee.ImageCollection(lt5.merge(le7).merge(lc8)); // merge the individual sensor collections into one imageCollection object
   
    return mergedCollection;   
                                     
};





//STATS BANDS
var getBandsStats = function(Collection){
  var percentImage = Collection.reduce(ee.Reducer.percentile([15,25,50,75,85]))
  return percentImage
}

var getIndexStats = function(Collection){
  var percentImage = Collection.reduce(ee.Reducer.percentile([15,25,50,75,90]))
  return percentImage
}




// growSeason


var annualSRcollection_GrowSeason = getCombinedSRcollection(startYear, '12-01', '05-31', aoi)
//Band stats
var GrowSeason_STATS = getBandsStats(annualSRcollection_GrowSeason
                                          .map(function(img){return img.float()}))
//inedex stats
var GrowSeason_IndexSTATS = getIndexStats(annualSRcollection_GrowSeason
                                             .map(GetIndex).map(function(img){return img.float()})
                               )
GrowSeason_STATS = GrowSeason_STATS.addBands(GrowSeason_IndexSTATS)                               



// off-growSeason
var annualSRcollection_nonGrowSeason = getCombinedSRcollection(startYear, '06-01', '11-30', aoi)


//Band stats
var NON_GrowSeason_STATS = getBandsStats(annualSRcollection_nonGrowSeason
                                          .map(function(img){return img.float()}))
                                          
//inedex stats                                     
var NON_GrowSeason_IndexSTATS = getIndexStats(annualSRcollection_nonGrowSeason
                                             .map(GetIndex).map(function(img){return img.float()})
                               )                                         


NON_GrowSeason_STATS= NON_GrowSeason_STATS.addBands(NON_GrowSeason_IndexSTATS)


var bands=['B4_p85','B5_p15','B3_p15']
//var bands=['NDVI_p90','NDVI_p50','NDVI_p15']
var visParams = {
  bands: bands,
  min: 0,
  max: 3000,
  gamma: 1.0,
};
Map.addLayer(GrowSeason_STATS.clip(aoi),visParams,'layer1')
Map.centerObject(aoi)

var elevation_img = ee.Image('USGS/SRTMGL1_003').clip(aoi)
//var slope = ee.Terrain.slope(elevation_img);


Export.image.toDrive({
  image: GrowSeason_STATS.addBands(NON_GrowSeason_STATS)
                         .addBands(elevation_img).int16().clip(aoi),
  description: 'FinalImage_STATS_'+startYear,
  scale: 30,
  region:aoi.bounds(),
  folder: 'FinalImage_STATS_'+startYear, 
  crs: 'EPSG:4326',
  maxPixels: 9999999999999
});  






