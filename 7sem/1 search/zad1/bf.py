def BruteForce(text, sequence):
	result = []
	counter = 0
	i = 0
	while i < (len(text)-(len(sequence))):
		for j in range(0, (len(sequence))):
			counter += 1
			# counts the number of comparisons by IF below
			if text[i+j] != sequence[j]:
				# To prevent problems when first letters don't match
				if j == 0:
					i += 1
				else:
				# If some letters match
					i += j
				break
			# If there is a full match
			if j == (len(sequence)-1):
				if (i + j) < len(text):
					i += j
					result = result + [i-j]
	return counter
