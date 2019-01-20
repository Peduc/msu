def Cocktail(Sequence):
	NewSeq=Sequence
	j = 0
	count_comp=0
	count_trans=0
	right = len(NewSeq)-1
	while j <= right:
		# print(count)
		for i in range(j, right):
			count_comp+=1
			# comparison of elements by IF below
			if NewSeq[i]>NewSeq[i + 1]:
				count_trans+=1
				NewSeq[i],NewSeq[i + 1]=NewSeq[i + 1],NewSeq[i]
		right-=1
		for i in range(right, j, -1):
			count_comp+=1
			# comparison of elements by IF below
			if NewSeq[i-1] > NewSeq[i]:
				count_trans+=1
				# transition of two elements
				NewSeq[i], NewSeq[i-1] = NewSeq[i-1], NewSeq[i]
		j+=1
	return count_comp,count_trans