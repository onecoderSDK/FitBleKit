#ifndef _PROCESS_H_
#define _PROCESS_H_

typedef float float32_t;
typedef double float64_t;

extern int norm_abs(double *x, int len);
extern void filter(double *b, double *a, double *zi, double *x, double *y, int length, int order);
extern void alg_iir_filter_f64(float64_t *b,float64_t *a,float64_t *zi,unsigned int nfilt,float64_t *pSrc,unsigned int blockSize,float64_t *pDst);
extern void alg_iir_filtfilt_f64(float64_t *b,float64_t *a,float64_t *zi, unsigned int filtOrder,float64_t *pSrc,unsigned int blockSize,float64_t *pDst);
extern void Conv(int shapeId, double *signal, int signalLength, double *filter, int filterLength, double outConv[], int *convLength);
extern double mean(double sum, int length);
extern void minus(double *x, double *y, double *z, int length);
extern void mov_mean(double *x, double *y, int length, int kernel_size);
extern void baseline_wander(double *x, double *y, int fs, int length);
#endif