#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>


typedef float float32_t;
typedef double float64_t;


int norm_abs(double *x, int len)
{
#define EPS 0.00001
  double max = 0;
  int i;

  for(i=0; i<len; i++)
  {
    if( fabs(x[i]) > max)
      max = x[i];
  }

  if(max > EPS)
  {
    for(i=0; i<len; i++)
    {
      x[i] /= max;
    }
  }
  else
    return -1;  //  max is too small
  
  return 1;
}

/* filter函数*/
void filter(double *b, double *a, double *zi, double *x, double *y, int length, int order){

    int filtOrder = order; //滤波器阶数

    double *pb = b, *pa = a;  //存储参数a,b的临时指针

    double *px, *py;    //存储x,y的临时指针

    int i, j;  //循环变量

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

/**
  @} end of FILTFILT group
 */

/**
  @brief         Floating-point IIR filter.
  @param[in]     S               definition of the filter.
  @param[in]     pSrc            points to the input signal to be filtered.
  @param[in]     blockSize       size (length) of the input singal.
  @param[out]    pDst            points to the filtered signal.
  @return        None
 **
 **/

void alg_iir_filter_f64(
  float64_t *b,
  float64_t *a,
  float64_t *zi,
  unsigned int nfilt,
  float64_t *pSrc,
  unsigned int blockSize,
  float64_t *pDst)
{
  float64_t *pStates;    /* points to the buffer states */
  unsigned int filtOrder = nfilt; /* filter order */
  float64_t *pb = b, *pa = a;  /* temporary poointer */
  float64_t *px, *py;    /* Temporary pointers for state and coef */
  unsigned int i, j;                     /* loop counter */

	/* Transposed Direct form 2 implementation, see more details in Openheimer book */

	pStates = (float64_t*)calloc(filtOrder, sizeof(float64_t)); /* allocate memory space */
	
  /*initialize by initial condition */
  px = zi; /* if zero condition exists */
  py = pSrc;
  for (i = 0; i < filtOrder - 1U; i++)
	{
		pStates[i] = (*px++) * (*py);  /* zi * y(1) */
    // pStates[i] = *px++;
	}
  pStates[filtOrder-1] = 0;

	/* initialize the destination array (output signal) 0 */
  py = pDst;
	for (i = 0; i < blockSize; i++)
	{
    *py++ = 0.0f;
	}

  /* filter(b, a, signal) Direct form II IIR filter Implementation */
  /* loop i for signal length */
  px = pSrc;
  py = pDst;
	for(i = 0; i < blockSize; i++)
	{

		/* loop j for buffer states */
    for (j = 0; j < filtOrder; j++)
		{
			/* update buffer states from 1 to N-1 */
			if (j == 0)
			{
				pStates[0] =  pb[0] * (*px) + pStates[0];  /* buffer state 0 is b(0)*x(n)+buffer(0)*/
				*py = pStates[0]; /* filtered signal equals to pStates[0] */
			}
			else
			{
				/* update all the buffer states from 0 to filtOrder-1. Note that the last buffer states is 
          always 0 to make this structure complete */
				pStates[j-1] =  pb[j] * (*px) - pa[j] * (*py)
				           + pStates[j];
			}
		}

    /* next sample to be processed */		
    px++;
    py++;
	}

  free(pStates);
  pStates = NULL;
}


void alg_iir_filtfilt_f64(
  float64_t *b,
  float64_t *a,
  float64_t *zi,      // zero condition if exisits otherwise 0
  unsigned int filtOrder,
  float64_t *pSrc,
  unsigned int blockSize,
  float64_t *pDst)
{
  float64_t *pStates;    /* points to the buffer states */
  //float64_t *pb = b, *pa = a;  /* temporary poointer */
  float64_t *px, *py;        /* Temporary pointers for state and coef */
  unsigned int i;             /* loop counter */
  float64_t *padSignal, *filtSignal;  /* padd the signal for filtfilt */
  unsigned int padBlockSize;     /* padded block length */

	/**-------------------------------------------------------------------------------
   **  Allocate space for data initial and final states concatenation, and add 
   **  3*filtOrder padding in the beginnig and at the end to take care of the 
   **  transition effect.
  ** ------------------------------------------------------------------------------*/
	
  /* Create temporary signal for padding and intermidiate filt signal */
  padBlockSize = 2*3*(filtOrder-1U) + blockSize;
  padSignal = (float64_t *)calloc(padBlockSize, sizeof(float64_t));
  filtSignal = (float64_t *)calloc(padBlockSize, sizeof(float64_t));
  pStates = (float64_t *)calloc(filtOrder, sizeof(float64_t));
  
  /* prefix 3*filtOrd */
  px = pSrc + 3U*(filtOrder-1U); /* points to the 3filtOrder and revert back for padding*/
  py = padSignal;  /* points to the start of the padSignal */
  i = 3*(filtOrder-1U);
  /* 2*x(1)-% yc = [2*xc(1)-xc(nfact+1:-1:2); xc; 2*xc(end)-xc(end-1:-1:end-nfact)] */
  do
  {
    *py++ = 2.0*(*pSrc) - (*px--); 
    i--;
  } while (i > 0U);

  /* copy signal to paddedSignal */
  px = pSrc;
  i = blockSize;
  do
  {
    *py++ = *px++;
    i--;
  } while (i > 0U);
  
  /* pad another 3*filtOrd samples*/
  // px = pSrc+blockSize-2U;
  px = &(pSrc[blockSize-2U]);
  i = 3U*(filtOrder-1U);
  do
  {
    *py++ = 2.0f*pSrc[blockSize-1U] - (*px--);
    i--;
  } while (i > 0U);  

  /**------------------------------------------------------------------------------
   **  Call iir filter to process the padded signal, ie, forward pass for filtfilt
  **------------------------------------------------------------------------------*/

  // for(i=0; i< padBlockSize; i++)
  //   printf("%.2lf, ", *(padSignal+i));


  // printf("\n");

  // multipy the zi with y[1]
  for(i=0; i<filtOrder-1; i++)
    pStates[i] = zi[i] * (*padSignal);  // z(i) * y(1)
  pStates[filtOrder-1] = 0;
  
  filter(b, a, pStates, padSignal, filtSignal, padBlockSize, filtOrder);
  // alg_iir_filter_f64(b, a, pStates, filtOrder, padSignal, padBlockSize, filtSignal);
  
  // for(i=0; i< padBlockSize; i++)
  //   printf("%.15lf, ", *(filtSignal+i));


  // printf("\n");

  /* back ward pass for filtfilt */
  px = filtSignal+padBlockSize-1U;
  py = padSignal;
  i = padBlockSize;

  /*reverse the order of the signal  and filter again */
  do
  {
    *py++ = *px--;
    i--;
  } while (i > 0U);
  
  /**------------------------------------------------------------------------------
   **  Call iir filter to process the padded signal, ie, backward pass for filtfilt
  **------------------------------------------------------------------------------*/

  // multipy the zi with y[1]
  for(i=0; i<filtOrder-1; i++)
    pStates[i] = zi[i] * (*padSignal);  // z(i) * y(1)
  pStates[filtOrder-1] = 0;
  
  filter(b, a, pStates, padSignal, filtSignal, padBlockSize, filtOrder);

  // alg_iir_filter_f64(b, a, pStates, filtOrder, padSignal, padBlockSize, filtSignal);

  // for(i=0; i< padBlockSize; i++)
  //   printf("%.15lf, ", *(filtSignal+i));


  // printf("\n");


  /*extract middel blockSize samples of filtfilt samples for output pDst */
  px = filtSignal+blockSize+3*(filtOrder-1U)-1U;
  i = blockSize;
  py = pDst;
  do
  {
    *py++ = *px--;
    i--;
  } while (i > 0U);

  py = pDst;
  i = blockSize;

  // for(i=0; i< blockSize; i++)
  //   printf("%.15lf, ", *(pDst+i));


  // printf("\n");

  /* free the intermediate temporary signal */
  free(padSignal);
  padSignal = NULL;
  free(filtSignal);
  filtSignal = NULL;
}

    /**
 * @brief 卷积运算
 * @param shapeId 卷积结果处理方式
 * @param double *signal, int signalLength, // 输入信号及其长度
 * @param double *filter, int filterLength, // 输入滤波器及其长度
 * @param double outConv[], int *convLength)   // 输出卷积结果及其长度
 */
void Conv(int shapeId, double *signal, int signalLength, double *filter, int filterLength, double outConv[], int *convLength)
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

/* calculation mean*/
double mean(double sum, int length){

    return sum / length;
}

/* calculation minus*/
void minus(double *x, double *y, double *z, int length){
	int i;
    for (i = 0; i < length; i++){
        z[i] = x[i] - y[i];
    }
}

/* calculation mov_mean*/
void mov_mean(double *x, double *y, int length, int kernel_size){
    int padding_length;

    padding_length= (kernel_size - 1) / 2;

    double sum = 0;
    int i;
    for (i = 0; i < length; i++){
        if (i - padding_length < 0){
			int m;
            for(m = 0; m < i + padding_length + 1; m++){
                sum += x[m];}
            y[i] = mean(sum, (i+padding_length+1));
            sum = 0;
        }
        else if(i + padding_length >= length){
			int n;
            for(n = i-padding_length; n < length;n++ ){
                sum += x[n];}
            y[i] = mean(sum, length-i+padding_length);
            sum = 0;
        }
        else{
			int z;
            for(z = i-padding_length; z < i+padding_length+1; z++){
                sum += x[z];}
            y[i] = mean(sum, kernel_size);
            sum = 0;
        }

    }

}

/* remove baseline_wander*/
void baseline_wander(double *x, double *y, int fs, int length){

    int kernel_size;

    double *inter_y;

    double *inter_y1;

    inter_y = (double *)malloc(sizeof(double ) * length);

    inter_y1 = (double *)malloc(sizeof(double ) * length);


    kernel_size =  (int)(round(0.2*fs));

    if (kernel_size % 2 == 0){
        kernel_size += 1;
    }

    mov_mean(x, inter_y, length, kernel_size);

    kernel_size =  (int)(round(0.6*fs));

    if (kernel_size % 2 == 0){
        kernel_size += 1;
    }

    mov_mean(inter_y, inter_y1, length, kernel_size);

    minus(x, inter_y1, y, length);

    free(inter_y);

    free(inter_y1);

}