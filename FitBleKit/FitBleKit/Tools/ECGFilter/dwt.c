#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>



int SignalExtension(int typeId, int modeId, double *signal, int sigLength, int filterLength, double out[])
{
    if((NULL == signal)||(NULL == out))
        return -1;

    if(0 != typeId) // 仅适用于1D的信号
        return -1;

    if(sigLength < filterLength ) // 滤波器的长度应该小于信号的长度
        return -1;

    int i; //局部变量，仅在函数块内有效
    int extendLength = filterLength - 1;

    if(modeId == 0) // 信号对称拓延
    {
        for(i=0; i < sigLength; i++)
        {
            out[extendLength + i] = signal[i];
        }
        for(i=0; i < extendLength; i++)
        {
            out[i] = out[2 * extendLength - i - 1];       // 左边沿对称延拓
            out[sigLength + extendLength + i] = out[extendLength + sigLength - i - 1]; // 右边沿对称延拓
        }

        return sigLength + 2 * extendLength;
    }
    else if(modeId == 1)//信号周期拓延
    {
        for( i = 0; i < extendLength; i++ )
            out[i] = signal[sigLength - extendLength + i];

        for ( i = 0; i < sigLength; i++ )
            out[extendLength + i] = signal[i];

        return sigLength + extendLength;
    }
    return 1;
}

void UpSampling(double *signal, int signalLength, double *out)
{
    int i;

    for (i = 0; i < signalLength; i++){
        out[2 * i] = signal[i];
        out[2 * i +1] = 0;
    }
}

void DownSampling(double *signal, int signalLength, double *out){
    int i, m;
    m = signalLength / 2;

    for(i = 0; i < m; i++){
        out[i] = signal[2 * i + 1];
    }
}

void ConvDwt(int shapeId, double *signal, int signalLength, double *filter, int filterLength, double outConv[], int *convLength)
{
    if((NULL == signal) || (NULL == filter) || (NULL == outConv))
        return ;

    int n, k, kMin, kMax, p;

    if(shapeId == 0)
    {
        *convLength = signalLength + filterLength - 1;
        for (n = 0; n < *convLength; n++)
        {
            outConv[n] = 0;

            kMin = (n >= filterLength - 1) ? n - (filterLength - 1) : 0;
            kMax = (n < signalLength - 1) ? n : signalLength - 1;

            for (k = kMin; k <= kMax; k++)
            {
                outConv[n] += signal[k] * filter[n - k];
            }
        }
    }
    else if(shapeId == 1)
    {
        *convLength = signalLength - filterLength + 1;
        for (n = filterLength - 1; n < signalLength; n++)
        {
            p = n - filterLength + 1;
            outConv[p] = 0;

            kMin = (n >= filterLength - 1) ? n - (filterLength - 1) : 0;
            kMax = (n < signalLength - 1) ? n : signalLength - 1;

            for (k = kMin; k <= kMax; k++)
            {
                outConv[p] += signal[k] * filter[n - k];
            }
        }
    }
    else
        return ;

}

int WaveletDecomposition(double *signal, int signalLength, double *filterLow, double *filterHigh, int filterLength, double *cA, double *cD){
    if (signalLength < filterLength)
        return -1;

    if ((signal == NULL)||(cA == NULL)||(cD == NULL))
        return -1;

    int decLength = (signalLength + filterLength - 1) / 2;

    int convLength = 0;

    double *extendSignal;
    extendSignal = (double *)malloc(sizeof(double) * (signalLength + 2 * filterLength - 2));

    double *convLow;
    convLow = (double *)malloc(sizeof(double) * (signalLength + filterLength - 1));

    double *convHigh;
    convHigh = (double *)malloc(sizeof(double) * (signalLength + filterLength - 1));

    if ((extendSignal == NULL) || (convLow == NULL) || (convHigh == NULL))
    {
        return -1;
    }
    SignalExtension(0, 0 , signal, signalLength, filterLength, extendSignal);

    ConvDwt(1, extendSignal, signalLength + 2 * filterLength - 2, filterLow, filterLength, convLow, &convLength);
    ConvDwt(1, extendSignal, signalLength + 2 * filterLength - 2, filterHigh, filterLength, convHigh, &convLength);

    //�²���
    DownSampling(convLow, signalLength + filterLength - 1, cA);
    DownSampling(convHigh, signalLength + filterLength - 1, cD);

    free(extendSignal);
    extendSignal = NULL;

    free(convLow);
    convLow = NULL;

    free(convHigh);
    convHigh = NULL;

    return decLength;


}

int WaveletReconstruction(double *cA, double *cD, int cALength, int recLength, double *recLow, double *recHigh,int filterLength, double *recSignal){
    if((NULL == cA)||(NULL == cD)||(NULL == recSignal))
        return -1;


    int i, k;
    int conv_len = 0;

    double *convDataLow = (double *)malloc(sizeof(double) *(2 * cALength - 1 + filterLength - 1));

    double *convDataHigh = (double *)malloc(sizeof(double) *(2 * cALength - 1 + filterLength - 1));

    double *cATemp = (double *)malloc(sizeof(double) *(2 * cALength));

    double *cDTemp = (double *)malloc(sizeof(double) *(2 * cALength));


    if ((convDataLow == NULL) || (convDataHigh == NULL) || (cATemp == NULL) ||(cDTemp == NULL)) {
        return -1;
    }

    memset(convDataLow, 0, (recLength + filterLength - 1) * sizeof(double)); // 清0
    memset(convDataHigh, 0, (recLength + filterLength - 1) * sizeof(double)); // 清0
    memset(cATemp, 0, 2 * cALength * sizeof(double)); // 清0
    memset(cDTemp, 0, 2 * cALength * sizeof(double)); // 清0


    UpSampling(cA, cALength, cATemp);
    UpSampling(cD, cALength, cDTemp);

    ConvDwt(0, cATemp, 2 * cALength-1, recLow, filterLength, convDataLow, &conv_len);
    conv_len = 0;
    ConvDwt(0, cDTemp, 2 * cALength-1, recHigh, filterLength, convDataHigh, &conv_len);

    k = (conv_len - recLength) / 2;
    for(i = 0; i < recLength; i++)
    {
        recSignal[i] = convDataLow[i + k] + convDataHigh[i + k];
    }

    free(cATemp);
    cATemp = NULL;

    free(cDTemp);
    cDTemp = NULL;

    free(convDataLow);
    convDataLow = NULL;

    free(convDataHigh);
    convDataHigh = NULL;

    return recLength;

}
void sort(double *signal, int left, int right)
{
    if(left >= right)
    {
        return ;
    }
    int i = left;
    int j = right;
    double key = signal[left];
     
    while(i < j)
    {
        while(i < j && key <= signal[j])
        
        {
            j--;
        }
         
        signal[i] = signal[j];
       
        while(i < j && key >= signal[i])

        {
            i++;
        }
         
        signal[j] = signal[i];
    }
     
    signal[i] = key;
    sort(signal, left, i - 1);
    sort(signal, i + 1, right);
}

double median(double *array, int arrayLength) {
    sort(array, 0, arrayLength-1);

    if (array == NULL)
        return -1;

    int index = ceil(arrayLength / 2);

    if (arrayLength % 2 == 0)
    {
        double median = (array[index] + array[index-1]) / 2;
        return median;
    } else
    {
        double median = array[index-1];
        return median;
    }
}

double max(double *array, int array_length){
    if (array == NULL)
        return -1;

    double max = array[0];

    int i;
    for (i = 0; i < array_length; i++)
    {
        if (array[i] > max){
            max = array[i];
        }
    }
    return max;
}

double sign(double array){
    if (array == 0)
        return 0;
    else if(array > 0)
    {
        return 1;
    } else
    {
        return -1;
    }
}

double AdaptiveThresholds(double *signal, int signal_length, double *db1_low, double *db1_high, double *cA, double *cD){
    if ((signal == NULL)||(cA == NULL)||(cD == NULL))
        return -1;

    double thr = sqrt(2 * log(signal_length));

    //printf("thr: %lf\n", thr);

    WaveletDecomposition(signal, signal_length, db1_low, db1_high, 2, cA, cD);
    int i;
    for (i = 0; i < (signal_length+1)/2; i++)
    {
        cD[i] = fabs(cD[i]);
    }

    double normalize = median(cD, (signal_length+1)/2);


    if (normalize == 0)
    {
        normalize = 0.05 * max(cD, (signal_length+1)/2);
    }

    thr = normalize * thr / 0.6745;

    return thr;

}

void SoftThreshold(double *coefficient, int length, double thresholds){
	int i;
    for (i = 0; i < length; i++){

        if (fabs(coefficient[i]) <= thresholds)

            coefficient[i] = 0;

        else{

            coefficient[i] = sign(coefficient[i]) * (fabs(coefficient[i]) - thresholds);
        }
    }
}

int Wavelet(double *signal, int signalLength, double *decLow, double *decHigh, double *recLow, double *recHigh,
        int filterLength, double *db1Low, double *db1High, double *recSignal){
        double *cA1 = (double *)malloc(sizeof(double) * ((signalLength + filterLength - 1) / 2));

        double *cD1 = (double *)malloc(sizeof(double) * ((signalLength + filterLength - 1) / 2));

        if ((cA1 == NULL)||(cD1 == NULL)){

            return -1;

        }

        int decLengthLevel1 = WaveletDecomposition(signal, signalLength, decLow, decHigh, filterLength, cA1, cD1);

        double *cA2 = (double *)malloc(sizeof(double) * ((decLengthLevel1 + filterLength - 1) / 2));

        double *cD2 = (double *)malloc(sizeof(double) * ((decLengthLevel1 + filterLength - 1) / 2));

        if ((cA2 == NULL)||(cD2 == NULL)){

            return -1;

        }

        int decLengthLevel2 = WaveletDecomposition(cA1, decLengthLevel1, decLow, decHigh, filterLength, cA2, cD2);

        double *cA3 = (double *)malloc(sizeof(double) * ((decLengthLevel2 + filterLength - 1) / 2));

        double *cD3 = (double *)malloc(sizeof(double) * ((decLengthLevel2 + filterLength - 1) / 2));

        if ((cA3 == NULL)||(cD3 == NULL)){

            return -1;

        }

        int decLengthLevel3 = WaveletDecomposition(cA2, decLengthLevel2, decLow, decHigh, filterLength, cA3, cD3);

        double *cA = (double *)malloc(sizeof(double) * ((signalLength+1)/2));

        double *cD = (double *)malloc(sizeof(double) * ((signalLength+1)/2));

        if ((cA == NULL)||(cD == NULL)){


            return -1;
        }

        double thr3 = AdaptiveThresholds(signal, signalLength, db1Low, db1High, cA, cD);

        thr3 = thr3 / log10(4);

        //printf("debug:重构之前%lf\n", thr3);

        SoftThreshold(cD3, decLengthLevel3, thr3);

        
        WaveletReconstruction(cA3, cD3, decLengthLevel3, decLengthLevel2, recLow, recHigh, filterLength, cA2);

		int i;
        //printf("debug:重构之后\n");
        for(i = 0; i < ((decLengthLevel1 + filterLength - 1) / 2); i++)
        {
            cD2[i] = 0;
        }

        WaveletReconstruction(cA2, cD2, decLengthLevel2, decLengthLevel1, recLow, recHigh, filterLength, cA1);

		int j;
        for(j = 0; j < ((signalLength + filterLength - 1) / 2); j++)
        {
            cD1[j] = 0;
        }

        int recLengthSignal = WaveletReconstruction(cA1, cD1, decLengthLevel1, signalLength, recLow, recHigh, filterLength, recSignal);

        free(cA1);
        cA1 = NULL;

        free(cA2);
        cA2 = NULL;

        free(cA3);
        cA3 = NULL;

        free(cD1);
        cD1 = NULL;

        free(cD2);
        cD2 = NULL;

        free(cD3);
        cD3 = NULL;

        free(cA);
        cA = NULL;

        free(cD);
        cD = NULL;

        return recLengthSignal;
    }

/* filter函数*/
void FilterDwt(double *b, double *a, double *zi, double *x, double *y, int length, int order){

    int filtOrder = order;

    double *pb = b, *pa = a;

    double *px, *py;

    int i, j;

    py = y;

    for (i = 0; i < length; i++)
    {
        *py++ = 0.0f;
    }

    /* filter(b, a, signal) Direct form II IIR filter Implementation */
    /* loop i for signal length */
    px = x;
    py = y;
    for(i = 0; i < length; i++)
    {

        /* loop j for buffer states */
        for (j = 0; j < filtOrder; j++)
        {
            /* update buffer states from 1 to N-1 */
            if (j == 0)
            {
                zi[0] =  pb[0] * (*px) + zi[0];  /* buffer state 0 is b(0)*x(n)+buffer(0)*/
                *py = zi[0]; /* filtered signal equals to pStates[0] */
            }
            else
            {
                /* update all the buffer states from 0 to filtOrder-1. Note that the last buffer states is
          always 0 to make this structure complete */
                zi[j-1] =  pb[j] * (*px) - pa[j] * (*py)
                                + zi[j];
            }
        }

        /* next sample to be processed */
        px++;
        py++;
    }
}
