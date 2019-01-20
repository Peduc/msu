def RabinKarp(text, sequence, d, q):
	n = len(text)
	m = len(sequence)
	#d^(m-1) mod q
	h = pow(d,m-1,q)
	hseq = 0
	hs = 0
	counter = 0
	result = []
	#First hashing:
	for i in range(m): 
		#ord gives us a number from symbol
		hseq = (d*hseq+ord(sequence[i]))%q
		hs = (d*hs+ord(text[i]))%q
		
	#Main comparison (src.Wikipedia)
	for s in range(n-m+1):
		# counter+=1
		# counts the number of comparisons by IF below
		#Hash comparison
		if hseq == hs:
			flag = 1
			#Symbol comparison
			for i in range(m):
				counter+=1
				# *counts the number of comparisons by IF below
				if sequence[i] != text[s+i]:
					# counter+=1
					flag = 0
					break
			if flag:
				result = result + [s]
		if s < n-m:
			#Rolling hash
			#Deleting s letter
			hs = (hs-h*ord(text[s]))%q
			#Adding s+m letter
			hs = (hs*d+ord(text[s+m]))%q 
			#Check that hs is positive
			hs = (hs+q)%q 
	return counter