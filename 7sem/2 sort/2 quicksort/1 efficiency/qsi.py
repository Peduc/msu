def quickSortIterative(arr,low,high): 
	import prttn as pt
	count=0
	new_count=0
	# Create an auxiliary stack 
	size=high-low+1
	stack=[0]*(size) 
	# initialize top of stack 
	top=-1
	# push initial values of l and high to stack 
	top=top+1
	stack[top]=low 
	top=top+1
	stack[top]=high 
	# Keep popping from stack while is not empty 
	while top >= 0: 
		# Pop high and low 
		# count+=1
		high = stack[top] 
		top=top-1
		low=stack[top] 
		top=top-1

		# Set pivot element at its correct position in 
		# sorted array 
		p,new_count=pt.partition(arr, low, high)
		count+=new_count

		# If there are elements on left side of pivot, 
		# then push left side to stack 
		if p-1>low : 
			# count+=1
			top=top+1
			stack[top]=low  
			top=top+1
			stack[top]=p-1

		# If there are elements on right side of pivot, 
		# then push right side to stack 
		if p+1<high:
			# count+=1
			top=top+1
			stack[top]=p+1
			top=top+1
			stack[top]=high  
	return count