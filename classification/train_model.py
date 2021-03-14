
import numpy as np
import os
import shapefile
import gdal
from sklearn.ensemble import RandomForestClassifier
import joblib


trainng_lables_total = np.load('/home/xiyali/classfication/trainng_lables_total.npy')
trainng_samples_total = np.load('/home/xiyali/classfication/trainng_samples_total.npy')
print(trainng_lables_total)
print(trainng_samples_total)
trainng_lables_total=trainng_lables_total.astype(np.int16)
trainng_samples_total=trainng_samples_total.astype(np.int16)


classifier = RandomForestClassifier(bootstrap=True, criterion='gini', max_depth=110, min_samples_leaf= 3, min_samples_split =12, n_estimators=300, n_jobs=-1)

classifier.fit(trainng_samples_total,trainng_lables_total)
joblib.dump(classifier, '/home/xiyali/classfication/train_model.m')
#joblib.load('/home/xiyali/test/train_model.m')
