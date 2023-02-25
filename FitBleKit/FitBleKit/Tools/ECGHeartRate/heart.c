#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "pt.h"
#include "findpeaks.h"
#include "process.h"
#define LENGTH 2000
#define FILTER 38
#define MAX_PEAKS_NO 1000
#define DISTANCE 60
#define FS 250
#define TIME 60

/*-----a, b, zi for ecg filter band pass  ecg_h-----*/
double b[7] = {0.001567010350607,-0.000000000000000,-0.004701031051822,-0.000000000000000,0.004701031051822,-0.000000000000000,-0.001567010350607};
double a[7] = {1.000000000000000,-5.368189227770622,12.137061481542393,-14.794795674735118,10.256323265142191,-3.834426575006392,0.604109699507273,};
double zi[6] = {-0.001567010350607,-0.001567010350607,0.003134020701214,0.003134020701216,-0.001567010350608,-0.001567010350607};

/*-----a, b, zi for ecg derivative filter ecg_d-----*/
double b1[7] = {31.250000000000000,51.250000000000000,44.999999999999986,5.000000000000004,-34.999999999999979,-56.249999999999993,-36.250000000000007};
double a1[7] = {1, 0, 0, 0, 0, 0, 0};
double zi1[6] = {-26.249999999999986,-77.499999999999986,-122.499999999999972,-127.499999999999972,-92.500000000000000,-36.250000000000007};  


int PreProcess(double *signal, double *ecg_h, double *ecg_m, int *locs)
{
    //ecg_d
    double* ecg_d = (double*)malloc(LENGTH * sizeof(double));

    //ecg_s
    double* ecg_s = (double*)malloc(LENGTH * sizeof(double));

    //filter
    double* filter = (double*)malloc(FILTER * sizeof(double));

    int rlength = 0;

    // ecg_h 
	alg_iir_filtfilt_f64 (b, a, zi, 7, signal, LENGTH, ecg_h);

    norm_abs(ecg_h, LENGTH);

    // ecg_d 
    alg_iir_filtfilt_f64 (b1, a1, zi1, 7, ecg_h, LENGTH, ecg_d);
    norm_abs(ecg_d, LENGTH);

    // ecg_s  平方
	int m;
    for(m = 0; m < LENGTH; m++)
    {
        ecg_s[m] = pow(ecg_d[m], 2);
    }

    // ecg_m  卷积
    int convLength = 0;
	int i;
    for(i = 0; i < FILTER; i++)
    {
        filter[i] = (double)(1.0) / FILTER;
    }
    Conv(0, ecg_s, LENGTH, filter, FILTER, ecg_m, &convLength);

    find_peaks_only_sort(ecg_m, LENGTH + FILTER -1, DISTANCE, locs, &rlength);
    int j;
    for (j = 0; j < rlength; j++)
    {
        locs[j] = locs[j] + 1;
    }

    //内存释放
    free(ecg_d);
    ecg_d = NULL;
    free(ecg_s);
    ecg_s = NULL;
    free(filter);
    filter = NULL;


    return rlength;
}

int Algorithms(double *ecg_h, double *ecg_m, int *locs, int *qrs_i_raw, int rlength)
{
    
    double *pks  = (double*)malloc(rlength * sizeof(double));
    int i;
    for(i = 0; i < rlength; i++)
    {
        pks[i] = ecg_m[locs[i]];
    }

    int p = PanTompKins(qrs_i_raw, pks, locs, rlength, ecg_h, ecg_m, LENGTH);

    free(pks);
    pks = NULL;
    
    return p;
}


int unique(int *rpeak, int rlength)
{

    int a = 1;
    int i;
    for (i = 1; i < rlength; ++i)
    {
        if (*(rpeak+i) != *(rpeak+i-1)) {

            *(rpeak+a) = *(rpeak+i);
            a++;
        }

    }
    return a;
}

int HeartRate(double* signal, int *heartRate, int *qrs_i_raw)
{
    //ecg_h
    double* ecg_h = (double*)malloc(LENGTH * sizeof(double));

    //ecg_m
    double* ecg_m = (double*)malloc((LENGTH + FILTER -1) * sizeof(double));

    //locs
    int *locs = (int*)malloc(MAX_PEAKS_NO * sizeof(int));

    int rlength = PreProcess(signal, ecg_h, ecg_m, locs);

    int indexLength = Algorithms(ecg_h, ecg_m, locs, qrs_i_raw, rlength);

    int **candidate_pair = (int **)malloc(sizeof(int *) * (indexLength-1));
	int i;
	for (i = 0; i < indexLength-1; ++i)
	{
		candidate_pair[i] = (int *)malloc(sizeof(int) * 2);
	}
	int m;
    for(m = 0; m < indexLength-1; m++)
    {
		int n;
        for (n = 0; n < 2; n++)
        {
            candidate_pair[m][n] = qrs_i_raw[m+n];
        }
    }

    double mean_rr = Interval(qrs_i_raw, 0, indexLength);

    int counter = 0;

    double rr_sum = 0;

    int j;
    for(j = 0; j < indexLength -1; j++)
    {
        double diff = candidate_pair[j][1] - candidate_pair[j][0];
        // printf("%lf\n", diff);
        if(diff <= 1.5 * mean_rr && diff >= DISTANCE)
        {
            rr_sum += diff;
            counter += 1;
        }
    }

    double rr_mean = rr_sum / counter;

    *heartRate = (int)((FS * TIME / rr_mean) + 0.5);
    
    free(ecg_h);
    ecg_h = NULL;
    free(ecg_m);
    ecg_m = NULL;
    free(locs);
    locs = NULL;
	int x;
    for (x = 0; x < indexLength-1; ++x)
    {
		free(candidate_pair[x]);
        candidate_pair[x] = NULL;
    }

    return indexLength;

}






    

  	
    