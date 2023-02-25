/* created by aury 2021/10/15 */
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#define FS 250

/*
* 函数:    Max:        最大值
* 参数:    signal      信号
*		   start       起点
*          end   	   终点
*/
double Max(double *signal, int start, int end)
{
    double max = signal[start];
	int i;
    for(i = start; i < end; i++)
    {
        if (signal[i] > max)
        {
            max = signal[i];

        }
    }
    return max;
}

int MaxInt(int *signal, int start, int end)
{
    int max = signal[start];
	int i;
    for(i = start; i < end; i++)
    {
        if (signal[i] > max)
        {
            max = signal[i];

        }
    }
    return max;
}


/*
* 函数:    MaxIndex:   最大值索引
* 参数:    signal      信号
*		   start       起点
*          end   	   终点
*/
int MaxIndex(double *signal, int start, int end)
{
    double max = signal[start];

	int max_index = start;
	int i;
    for(i = start; i < end; i++)
    {
        if (signal[i] > max)
        {
            max = signal[i];

			max_index = i;

        }
    }
    return max_index - start;
}

/*
* 函数:    Mean:       均值计算
* 参数:    signal      信号
*		   start       起点
*          end   	   终点
*/
double Mean(double *signal, int start, int end)
{
	double sum = 0;
    int i;
    for(i = start; i < end; i++)
    {
       sum += signal[i];
    }
    return sum / (end - start);
}

/*
* 函数:    Slope:      计算平均斜率
* 参数:    signal      信号
*		   start       起点
*          end   	   终点
*/
double Slope(double *signal, int start, int end)
{
	
	double *diff = (double*)malloc((end - start -1) * sizeof(double));
    int i;
	for(i = start; i < end -1; i++)
	{
		diff[i - start] = signal[i+1] - signal[i];
	}

	double slope = Mean(diff, 0, end-start-1);

	free(diff);
	diff = NULL;

	return slope;
}

/*
* 函数:    Interval:计算平均的RR间隔
* 参数:    signal         信号索引
*		   start          起点
*          end   	      终点
*/
double Interval(int *signal, int start, int end)
{
	int sum = 0;

	double mean_rr = 0;

	int *diff = (int*)malloc((end - start -1) * sizeof(int));
    int i;
	for(i = start; i < end -1; i++)
	{
		diff[i - start] = signal[i+1] - signal[i];
	}

    int j;
    for(j = 0; j < end-start-1; j++)
    {
       sum += diff[j];
    }

    mean_rr = (double)(sum) / (end - start -1);

	return mean_rr;
	
}
/*
* 函数:    改进的panTompkins算法
* 参数:    fs             采样频率
*		   *pks           候选R峰值的幅度
*          locs   	      候选R峰的索引(索引基于ecg_m)
*          length         候选R峰个数
*          *ecg_h         预处理最后信号状态
*          *ecg_m         巴特沃斯带通后信号状态
*          signalLength   信号长度
*/
int PanTompKins(int *qrs_i_raw, double *pks, int *locs, int length, double *ecg_h, double *ecg_m, int signalLength)
{
	/* Initialize Some Other Parameters */
	//存储预处理信号的R峰幅值
	double *qrs_c = (double*)malloc(length * sizeof(double));
	// 存储预处理信号的R峰索引
	int *qrs_i = (int*)malloc(length * sizeof(int));
	// 存储带通滤波信号的R峰幅值
	double *qrs_amp_raw = (double*)malloc(length * sizeof(double));
	// 存储带通滤波信号的R峰索引
	// int *qrs_i_raw = (int*)malloc(length * sizeof(int));
	//存储噪点幅度
	double *noise_c = (double*)malloc(length * sizeof(double));
	//存储噪点索引
	int *noise_i = (int*)malloc(length * sizeof(int));


	/* Initialize the training phase (2 seconds of the signal) to determine the THR_SIG and THR_NOISE */
	double thr_sig = Max(ecg_m, 0, 2*FS) / 3;
	double thr_noise = Mean(ecg_m, 0, 2*FS) / 2;
	double sig_lev = thr_sig;
	double noise_lev = thr_noise;

	/* Initialize bandpath filter threshold(2 seconds of the bandpass signal) */
	double thr_sig1 = Max(ecg_h, 0, 2*FS) / 3;
	double thr_noise1 = Mean(ecg_h, 0, 2*FS) / 2;
	double sig_lev1 = thr_sig1;
	double noise_lev1 = thr_noise1;

	/* Initialization symbols */
	int beat_c = 0;
	int beat_c1 = 0; 
	int noise_counter = 0;
	int not_noise = 0;
	int ser_back = 0;
	int skip = 0;                                                                  
	double m_selected_RR = 0;
	double mean_RR = 0;
	double y_i = 0;
	int x_i = 0;
	double slope1 = 0;
	double slope2 = 0;
	double flag = 0;
	int i;
	/* Thresholding and desicion rule */
	for(i = 0; i < length; i++)
	{
		
		if(locs[i] - (int)(0.15*FS+0.5) >=0 && locs[i] <= signalLength)
		{
			y_i = Max(ecg_h, locs[i]-(int)(0.15*FS+0.5)-1, locs[i]);
			x_i = MaxIndex(ecg_h, locs[i]-(int)(0.15*FS+0.5)-1, locs[i]);	
		}
		else
		{
			if (i == 0)
			{
				y_i = Max(ecg_h, 0, locs[i]);
				x_i = MaxIndex(ecg_h, 0, locs[i]);
				ser_back = 1;
			}else if (locs[i] >= signalLength)
			{
				y_i = Max(ecg_h, locs[i] - (int)(0.15*FS+0.5)-1, signalLength);
				x_i = MaxIndex(ecg_h, locs[i]- (int)(0.15*FS+0.5)-1, signalLength);
			}
		}
		/* update the heart_rate */
		if(beat_c >= 9)
		{
			mean_RR = Interval(qrs_i, beat_c-9, beat_c-1);
			double comp = (double) (qrs_i[beat_c-1] - qrs_i[beat_c-2]);

			if (comp <= 0.92 * mean_RR || comp >= 1.16 * mean_RR)
			{
				thr_sig = 0.5 * thr_sig;
				thr_sig1 = 0.5 * thr_sig1;
			}else{
				m_selected_RR = mean_RR;
			}
		}

		/* calculate the mean last 8 R waves to ensure that QRS is not */
		if (m_selected_RR)
		{
			flag = m_selected_RR;
		}else if (mean_RR && m_selected_RR ==0)
		{
			flag = mean_RR;
		}else{
			flag = 0;
		}
		if(flag)
		{
			//局部存储变量，循环结束即释放内存
			double pks_tmp = 0;
			int locs_tmp = 0; 
			double y_i_t = 0;
			int x_i_t = 0;
			if(locs[i] - qrs_i[beat_c-1] >= (int)(1.66*flag+0.5))
			{
				pks_tmp = Max(ecg_m, qrs_i[beat_c-1]+(int)(0.2*FS+0.5)-1, locs[i]-(int)(0.2*FS+0.5));
				locs_tmp = MaxIndex(ecg_m, qrs_i[beat_c-1]+(int)(0.2*FS+0.5)-1, locs[i]-(int)(0.2*FS+0.5));
				locs_tmp = qrs_i[beat_c-1] + (int)(0.2*FS+0.5) + locs_tmp -1;

				if(pks_tmp > thr_noise)
				{
					beat_c += 1;
					qrs_c[beat_c-1] = pks_tmp;
					qrs_i[beat_c-1] = locs_tmp;
					/*------------- Locate in Filtered Sig -------------*/
					if(locs_tmp <= signalLength)
					{
						y_i_t = Max(ecg_h, locs_tmp-(int)(0.15*FS+0.5)-1, locs_tmp);
						x_i_t = MaxIndex(ecg_h, locs_tmp-(int)(0.15*FS+0.5)-1, locs_tmp);
					}else{
						y_i_t = Max(ecg_h, locs_tmp-(int)(0.15*FS+0.5)-1, locs_tmp);
						x_i_t = MaxIndex(ecg_h, locs_tmp-(int)(0.15*FS+0.5)-1, locs_tmp);
					}
					if(y_i_t > thr_noise1)
					{
						beat_c1 += 1;
						qrs_i_raw[beat_c1-1] = locs_tmp - (int)(0.150*FS+0.5) + (x_i_t - 1);
						qrs_amp_raw[beat_c1-1] = y_i_t;
						sig_lev1 = 0.25 * y_i_t + 0.75 * sig_lev1;
					}
					not_noise = 1;
					sig_lev = 0.25 * pks_tmp + 0.75 * sig_lev;
				}
			}else
			{
				not_noise = 0;
			}
		}

		if(pks[i] >= thr_sig)
		{
			if(beat_c >= 3)
			{
				if(locs[i]- qrs_i[beat_c-1] <= (int)(0.36*FS+0.5))
				{
					slope1 = Slope(ecg_m, locs[i]-(int)(0.075*FS+0.5)-1, locs[i]);
					slope2 = Slope(ecg_m, qrs_i[beat_c-1]-(int)(0.075*FS+0.5)-1, qrs_i[beat_c-1]);
					if(fabs(slope1) <= fabs(0.5*slope2))
					{
						noise_counter += 1;
						noise_c[noise_counter-1] = pks[i];
						noise_i[noise_counter-1] = locs[i];
						skip = 1;
						noise_lev1 = 0.125 * y_i + 0.875 * noise_lev1;
						noise_lev = 0.125* pks[i] + 0.875* noise_lev;

					}else{
						skip = 0;
					}
				}
			}
			if(skip == 0)
			{
				// R峰计数
				beat_c += 1;
				// 存储R峰值
				qrs_c[beat_c-1] = pks[i];
				// 存储R索引
				qrs_i[beat_c-1] = locs[i];

				if (y_i >= thr_sig1)
				{
					beat_c1 += 1;
					if(ser_back == 1)
					{
						qrs_i_raw[beat_c1-1] = x_i;
					}else
					{
						qrs_i_raw[beat_c1-1] = locs[i] - (int)(0.150*FS+0.5) + (x_i - 1);
					}
					qrs_amp_raw[beat_c1-1] = y_i;

					//更新滤波信号等级阈值
					sig_lev1 = 0.125 * y_i + 0.875 * sig_lev1;
				}
				sig_lev = 0.125 * pks[i] + 0.875 * sig_lev;   
			}
		}else if(pks[i] < thr_sig && pks[i] >= thr_noise)
		{
			noise_lev = 0.125 * pks[i] + 0.875 * noise_lev;                        
         	noise_lev1 = 0.125 * y_i + 0.875 * noise_lev1;

		}else if (pks[i] < thr_noise)
		{
			//噪点计数加1
        	noise_counter = noise_counter + 1;
        	//存储噪点的幅度
        	noise_c[noise_counter-1] = pks[i];
        	//存储噪点的索引
        	noise_i[noise_counter-1] = locs[i]; 
        	//噪点等级自适应调整
        	noise_lev1 = 0.125 * y_i + 0.875 * noise_lev1;                        
        	noise_lev = 0.125 * pks[i] + 0.875 * noise_lev;
		}
		/* adjust the threshold with SNR */
		if(noise_lev != 0 || sig_lev != 0)
		{
			thr_sig = noise_lev + 0.25 * (fabs(sig_lev - noise_lev));
			thr_noise = 0.5 * thr_sig;
		}

		/* adjust the threshold with SNR for bandpassed signal */
		if(noise_lev1 != 0 || sig_lev1 != 0)
		{
			thr_sig1 = noise_lev1 + 0.25 * (fabs(sig_lev1 - noise_lev1));
			thr_noise1 = 0.5 * thr_sig1;
		}
		ser_back = 0;
		skip = 0;
		not_noise = 0;	
	}
    int j;
	/* Adjust Lengths */
	for(j = 0; j < beat_c1; j++)
	{
		qrs_i_raw[j] = qrs_i_raw[j];
	}

	return beat_c1;

}
