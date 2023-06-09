#ifndef _DENOISE_H_
#define _DENOISE_H_
#include "dwt.h"
#include <stdlib.h>
/*带通滤波器参数*/
double aDwt[5] = {1.000000000000000, -2.669119630281157, 2.599021317220820, -1.184450691988401, 0.254582110486002};
double bDwt[5] = {0.143593952368502, 0, -0.287187904737004, 0, 0.143593952368502};
/*50HZ陷波器参数*/
double IIR_B[3] = {0.979482760981449,  -0.605353637681125,   0.979482760981449};
double IIR_A[3] = {1.000000000000000 , -0.605353637681125,   0.958965521962899};
/*60HZ陷波器参数*/
double B_60[3] = {0.975478390750534, -0.122501589889689, 0.975478390750534};
double A_60[3] = {1.000000000000000, -0.122501589889689, 0.950956781501068};


/*db1参数*/
const double Lo_D[2] = {0.707106781186547, 0.707106781186547};
const double Hi_D[2] = {-0.707106781186547, 0.707106781186547};

double DecLow[12] = {0, 0, 0.039687088347405, 0.007948108637240,
                           -0.054463788468237, 0.345605281956033, 0.736660181428211, 0.345605281956033,
                           -0.054463788468237, 0.007948108637240, 0.039687088347405, 0};
double DecHigh[12] = {-0.013456709459119, -0.002694966880112, 0.136706584664329, -0.093504697400939,
                            -0.476803265798484, 0.899506109748648,  -0.476803265798484, -0.093504697400939,
                            0.136706584664329,  -0.002694966880112,  -0.013456709459119, 0};
double RecLow[12] = {0.013456709459119,  -0.002694966880112,  -0.136706584664329,  -0.093504697400939,
                           0.476803265798484,   0.899506109748648,   0.476803265798484,  -0.093504697400939,
                           -0.136706584664329,  -0.002694966880112,   0.013456709459119,  0};
double RecHigh[12] = {0, 0, 0.039687088347405, -0.007948108637240,
                            -0.054463788468237,  -0.345605281956033,   0.736660181428211,  -0.345605281956033,
                            -0.054463788468237,  -0.007948108637240,   0.039687088347405,   0};

extern void Denoise(double *signal, int signalLength, double *recSignal, double *zi_notch, double *zi_notch_60, double *zi_bandpass)
{
    //Denoise
    /*---------陷波器50工频去噪------------*/
    double *y_notch = (double *)malloc(sizeof(double ) * signalLength);
    FilterDwt(IIR_B, IIR_A, zi_notch, signal, y_notch, signalLength, 3);
    
    /*---------陷波器60工频去噪------------*/
    double *y_notch_60 = (double *)malloc(sizeof(double ) * signalLength);
    FilterDwt(B_60, A_60, zi_notch_60, y_notch, y_notch_60, signalLength, 3);
    /*---------巴特沃斯带通滤波用于基线去除-------------*/
    double *y_bandpass = (double *)malloc(sizeof(double ) * signalLength);
    FilterDwt(bDwt, aDwt, zi_bandpass, y_notch_60, y_bandpass, signalLength, 5);
    /*---------小波高频噪声去除------------------------*/
    Wavelet(y_bandpass, signalLength, DecLow, DecHigh, RecLow, RecHigh, 12, Lo_D, Hi_D, recSignal);

    free(y_notch);
    y_notch = NULL;
    free(y_notch_60);
    y_notch_60 = NULL;
    free(y_bandpass);
    y_bandpass = NULL;
    
}
#endif
