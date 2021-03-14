function [Dis] =latlon2Dis(lat1,lon1,lat2,lon2)
     EARTH_RADIUS = 6378.137;  %%KM
     radLat1 = deg2rad(lat1);
     radLat2 = deg2rad(lat2);
     a = abs(radLat1 - radLat2);
     b = abs(deg2rad(lon1) - deg2rad(lon2));
     s = power(sin(a/2),2) + cos(radLat1)*cos(radLat2)*power(sin(b/2),2);
     Dis = 2 * asin(sqrt(s)) * EARTH_RADIUS;
end