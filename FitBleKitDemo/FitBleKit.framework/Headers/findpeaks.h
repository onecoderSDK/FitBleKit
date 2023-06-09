#ifndef _FINDPEAKS_H_
#define _FINDPEAKS_H_

extern void swap(int* x, int* y);
extern void swap_double(double *x, double *y);
extern void buble_sort(int *arr, int n, int flag);
extern void sorted_order (double *arr, int *idx, int n);
extern int find_peaks_only_sort(double *src, int src_lenth, double distance, int *indMax, int *indMax_len);

#endif