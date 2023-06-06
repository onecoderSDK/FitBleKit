#ifndef _DWT_H_
#define _DWT_H_

extern int SignalExtension(int typeId, int modeId, double *signal, int sigLength, int filterLength, double out[]);
extern void UpSampling(double *signal, int signalLength, double out[]);
extern void DownSampling(double *signal, int signalLength, double out[]);
extern void ConvDwt(int shapeId, double *signal, int signalLength, double *filter, int filterLength, double outConv[], int *convLength);
extern int WaveletDecomposition(double *signal, int signalLength, double *filterLow, double *filterHigh, int filterLength, double *cA, double *cD);
extern int WaveletReconstruction(double *cA, double *cD, int cALength, int recLength, double *recLow, double *recHigh,int filterLength, double *recSignal);
extern double median(double *array, int arrayLength);
extern double max(double *array, int array_length);
extern double sign(double array);
extern double AdaptiveThresholds(double *signal, int signal_length, const double *db1_low, const double *db1_high, double *cA, double *cD);
extern void SoftThreshold(double *coefficient, int length, double thresholds);
extern int Wavelet(double *signal, int signalLength, double *decLow, double *decHigh, double *recLow, double *recHigh,
            int filterLength, const double *db1Low, const double *db1High, double *recSignal);
extern void FilterDwt(double *b, double *a, double *zi, double *x, double *y, int length, int order);
#endif
