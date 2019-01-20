class AlphDict:

	def __init__(self, elem):
		self.words = [elem]
		self.freq = [1]
		self.ops = [0]

	def __len__(self):
		return len(self.words)

	def insert(self, elem):
		i = 0
		flag = False
		ind = 0
		for i in range(len(self)):
			if elem == self.words[i]:
				self.freq[i] += 1
				flag = True
				break
		if not flag:
			if len(self) == 1:
				if elem > self.words[0]:
					# print(elem, self.words[0])
					self.words.append(elem)
					self.freq.append(1)
					self.ops.append(0)
				else:
					print(elem, self.words[0])
					self.words.insert(0, elem)
					self.freq.insert(0, 1)
					self.ops.insert(0, 0)
			else:
				# print(elem)
				for i in range(len(self)):
					# print(i, self.words[i], self.words[i+1])
					if (i == 0) and (elem < self.words[i]):
						# print(elem, self.words[i])
						self.words.insert(0, elem)
						self.freq.insert(0, 1)
						self.ops.insert(0, 1)
						break
					elif (i < len(self)-1) and (elem > self.words[i]) and (elem < self.words[i+1]):
						# print(self.words[i], elem, self.words[i + 1])
						self.words.insert(i+1, elem)
						self.freq.insert(i+1, 1)
						self.ops.insert(i+1, 0)
						break
					elif (i == len(self)-1) and (elem > self.words[i]):
						# print(elem, self.words[i])
						self.words.append(elem)
						self.freq.append(1)
						self.ops.append(0)
						break
		# print('Current array:', self.words)

	def printList(self):
		print("\n*****Alphabetical List******")
		for i in range(len(self)):
			print('Word:', self.words[i], 'Frequency:', self.freq[i], 'Number:', i)
