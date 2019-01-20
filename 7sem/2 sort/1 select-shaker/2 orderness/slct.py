def SelectSort(Sequence):
	NewSeq=Sequence
	count_comp=0
	count_trans=0
	if(len(NewSeq) == 0): 
		return
	for j in range(len(NewSeq)):
		min = j
		for i in range(j+1, len(NewSeq)):
			count_comp+=1
			# comparison of elements by IF below		
			if(NewSeq[i] < NewSeq[min]):
				min = i
		if(min != j):
			value = NewSeq[min]
			for l in range(min, j-1,-1):
				# transition of two elements
				count_trans+=1
				NewSeq[l] = NewSeq[l-1]
			NewSeq[j] = value
	return count_comp,count_trans