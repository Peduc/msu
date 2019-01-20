class hashlist:
	def __init__(self, value):
		self.value = value
		self.col = 0


class Table:

	def __init__(self, ht_size):
		self.ht_size = ht_size
		self.sublist = hashlist[self.ht_size]

		self.occ = 0
		self.coll = 0
		self.size = 0

	def __len__(self):
		return self.size

	def add(self, key, hash):
		# index of the new element
		point = hash % self.ht_size

		if self.sublist[p].insert(key):
			self.occ += 1
		else:
			self.coll += 1

		# self.size += 1

	def printTable(self):
		print("\n*****Binary tree******")
		for i in range(len(self)):
			print('Word:', self[i])
