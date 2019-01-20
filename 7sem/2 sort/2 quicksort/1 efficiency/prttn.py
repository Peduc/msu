def partition(arr, low, high): 
	i=(low-1)         # index of smaller element 
	pivot=arr[high]   # pivot 
	count=0;
	for j in range(low, high): 
		count+=1
		# If current element is smaller  
		# than or equal to pivot 
		if arr[j]<=pivot: 
		# increment index of 
		# smaller element 
			i+=1
			count+=1
			arr[i], arr[j] = arr[j], arr[i] 
	count+=1
	arr[i+1],arr[high]=arr[high],arr[i+1] 
	return i+1, count