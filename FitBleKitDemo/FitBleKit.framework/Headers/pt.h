#ifndef _PT_H_
#define _PT_H_

extern double Max(double *signal, int start, int end);
extern int MaxIndex(double *signal, int start, int end);
extern double Mean(double *signal, int start, int end);
extern double Slope(double *signal, int start, int end);
extern double Interval(int *signal, int start, int end);
extern int PanTompKins(int *qrs_i_raw, double *pks, int *locs, int length, double *ecg_h, double *ecg_m, int signalLength);

#endif