#define WINDOW_LENGTH 2037
#define MAX_PEAKS_NO 1000


void swap(int* x, int* y)
{
  int temp;
  temp = *x;
  *x = *y;
  *y = temp;
}

void swap_double(double *x, double *y)
{
  double temp;
  temp = *x;
  *x = *y;
  *y = temp;
}

/*
* 函数:  sorted_order
* 参数:    *arr        输入数组
*          *idx       源数组对应的下标序号
*          n    数组长度
* 返回：  数组的数值会被排序改变
*/
void buble_sort(int *arr, int n, int flag)
{
	int i, j;

	if (flag > 0)  // descending
	{
		for (i=0; i<n; i++)
		{
			for (j=i+1; j<n; j++)
			{
				if (arr[i] < arr[j])
				{
				swap(&arr[i], &arr[j]);
				}
			}
		}
	}
	else //  ascending
	{
		for (i=0; i<n; i++)
		{
			for (j=i+1; j<n; j++)
			{
				if (arr[i] >= arr[j])
				{
				swap(&arr[i], &arr[j]);
				}
			}
		}
	}
 
}

/*
* 函数:  sorted_order
* 参数:    *arr        输入数组
*          *idx       源数组对应的下标序号
*          n          数组长度
* 返回：  数组的数值会被排序改变
*/
void sorted_order (double *arr, int *idx, int n)
{
  int i, j;
 
  for (i=0; i<n; i++)
  {
    for (j=i+1; j<n; j++)
    {
      if (arr[i] < arr[j])
      {
        swap_double(&arr[i], &arr[j]);
        swap(&idx[i], &idx[j]);
      }
    }
  }
 
  // return  idx;
}

// 只计算波峰, 限制最多的peaks个数为MAX_PEAKS_NO个
/*
* 函数:  find_peaks_only
* 参数:    *src        源数据数组
*          src_lenth   源数据数组长度
*          distance    峰与峰,谷与谷的搜索间距
*          *indMax     找到的峰的index数组
*          *indMax_len 数组长度
*/
int find_peaks_only_sort(double *src, int src_lenth, double distance, int *indMax, int *indMax_len)
{

    int sign[WINDOW_LENGTH];  
    int idelete[MAX_PEAKS_NO];
    int temp_max_index[MAX_PEAKS_NO];
	int max_index = 0; 		// min_index = 0;
	// int bigger = 0;
	// float tempvalue = 0;
    double diff;

	// sorting before minimum distance elimination
	double sorted_peaks[MAX_PEAKS_NO];
	int sorted_peaks_idx[MAX_PEAKS_NO]; 

    // 循环控制变量
    int i, j;

    // 最大是 MAX_PEAKS_NO  初始化
	*indMax_len = 0;     	// *indMin_len = 0;  

	for (i=1; i<src_lenth; i++)
	{
		diff = src[i] - src[i-1];
		if (diff > 0)    // 局部上升状态 
        {
            sign[i-1] = 1;
        }
		else if (diff < 0)  // 局部下降
        {
            sign[i-1] = -1;
        }
		else               // 相邻点数值一致
        {
            sign[i-1] = 0;
        }
	}

	for (j=1; j<src_lenth-1; j++)
	{
		diff = sign[j] - sign[j-1]; // 判断最大局部峰值 ^  先上后下((-1) - 1)，或者先上后平(0-1)
		if ( (diff<0) && (max_index<MAX_PEAKS_NO))   // 防止内存越界
        {  
            indMax[max_index++] = j;  // 记录局部最大值的位置
        }
		// else if (diff>0)indMin[min_index++] = j;
	}


	//波峰  
	for(i=0; i<max_index; i++)  //初始化
	{
		idelete[i] = 0;
		sorted_peaks_idx[i] = indMax[i];
		sorted_peaks[i] = src[indMax[i]];
	}

	// 对局部最大值进行排序
	sorted_order(sorted_peaks, sorted_peaks_idx, max_index);

	// for(j=0; j<max_index; j++)
	// {
	// 	printf("%d ", sorted_peaks_idx[j]);
	// }
	// printf("\n"); 

	// 去除不满足minmum distance条件的极大值点
	for (i=0; i<max_index; i++)   // 最小distance 条件，去掉不满足最小distance的点
	{
		// matlab findpeaks function line 886
		if (!idelete[i])         // 参考matlab 与 python scipy findpeaks实现
		{
			for (j=0; j<max_index; j++)
			{
				// idelete[k] |= (indMax[k] - distance <= indMax[bigger] & indMax[bigger] <= indMax[k] + distance);
				idelete[j] |= ( (sorted_peaks_idx[i] - distance <= sorted_peaks_idx[j]) & 
				                    (sorted_peaks_idx[j] <= sorted_peaks_idx[i] + distance) );
			}
			idelete[i] = 0;
		}
	}

	j = 0;  // 记录删除过后的峰值数目
	for (i=0; i<max_index; i++) // 移动没有倍删除的点到temp_max_index数组里面
	{
		if (!idelete[i])  
        {
			temp_max_index[j++] = sorted_peaks_idx[i];
        }
	} // j 等于删除过后的峰值个数
	// sort the sorted_peaks and sorted_peaks_idx back to ascending order
	buble_sort(temp_max_index, j, -1); 

	for (i=0; i<max_index; i++)
	{
		if (i<j)
        {
			indMax[i] = temp_max_index[i];  // 用temp_max_index 里面的更新过的index来更新返回数组indMax
        }
		else
        {
			indMax[i] = 0;
        }
	}
	max_index = j;  // 更新删除过后的最大峰值数目
	*indMax_len = max_index;  // 返回的最大峰值数目

    return 1;  //成功找到峰值小于MAX_PEAKS_NO
}


