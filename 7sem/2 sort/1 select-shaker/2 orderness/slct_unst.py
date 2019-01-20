def selection_sort(Sequence_su):
	n=len(Sequence_su)
	i=0
	count_comp=0
	count_trans=0
	while i<n-1:
		min=i
		j=i+1
		while j<n:
			count_comp+=1
			if Sequence_su[j]<Sequence_su[min]:
				min=j 
			j+=1
		count_trans+=1
		Sequence_su[i],Sequence_su[min]=Sequence_su[min],Sequence_su[i]
		i+=1
	return count_comp,count_trans