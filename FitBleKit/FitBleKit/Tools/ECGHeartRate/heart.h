#ifndef _HEART_H_
#define _HEART_H_

extern int PreProcess(double *signal, double *ecg_h, double *ecg_m, int *locs);
extern int Algorithms(double *ecg_h, double *ecg_m, int *locs, int *qrs_i_raw, int rlength);
extern int HeartRate(double* signal, int *heartRate, int *rrInterval);
#endif