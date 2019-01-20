def quickSort(arr,low,high):
	import prttn as pt
	count=0
	if low < high: 
		# count+=1
		# pi is partitioning index, arr[p] is now 
		# at right place 
		# pi = pt.partition(arr, low, high)
		pi,new_count=pt.partition(arr, low, high)
		count+=new_count		
		# Separately sort elements before 
		# partition and after partition 
		if ((pi-1)-low) >= (high-(pi+1)):
			count += quickSort(arr, low, pi-1)
			count += quickSort(arr, pi+1, high)
		else:
			count += quickSort(arr, pi+1, high)
			count += quickSort(arr, low, pi-1)
	return count