def BubbleSingleSort(arr,count):
	next_seq=[]
	for i in range(len(arr)):
		# print(i)
		for j in range(len(arr)-1,i,-1):
			if arr[j]<arr[j-1]:
				arr[j],arr[j-1]=arr[j-1],arr[j]
		if (i==count):
			next_seq=arr.copy()
			# print(next_seq,'next',i)
	return next_seq
	
def StoneSingleSort(arr,count):
	next_seq=[]
	for i in range(len(arr)):
		# print(i)
		for j in range(len(arr)-1,i,-1):
			if arr[j]>arr[j-1]:
				arr[j],arr[j-1]=arr[j-1],arr[j]
		if (i==count):
			next_seq=arr.copy()
			# print(next_seq,'next',i)
	return next_seq