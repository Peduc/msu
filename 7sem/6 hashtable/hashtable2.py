class HashTable:
	def __init__(self, size):
		self.size = size
		self.slots = [None] * self.size
		self.thash = [None] * self.size
		self.count = [None] * self.size
		self.occupancy = 0
		self.collisions = 0

	def add(self, key, newhash):
		point = self.hashfunction(newhash, len(self.slots))
		chain_len = 1
		if self.slots[point] is None:
			self.slots[point] = key
			self.thash[point] = newhash
			self.count[point] = 1
			self.occupancy += 1
		else:
			if self.slots[point] == key:
				# print('Match', key)
				self.count[point] += 1
			else:
				# print('Collision', key,  self.slots[point],point)
				self.collisions += 1

				# collisions preventing mechanism

				nextslot = self.rehash(point, len(self.slots))
				# print(self.slots[nextslot], key)
				# print()
				while self.slots[nextslot] is None and (self.slots[nextslot] != key):
					nextslot = self.rehash(nextslot, len(self.slots))
					chain_len += 1
					# print(self.slots[nextslot])

				# print(chain_len,point)
				if self.slots[nextslot] is None:
					self.slots[nextslot] = key
					self.thash[nextslot] = newhash
					self.chain_len = chain_len
				else:
					self.thash[nextslot] = newhash  # replace

		return self.occupancy/self.size, self.collisions, chain_len

	def hashfunction(self, newhash, size):
		return newhash % size

	def rehash(self, oldhash, size):
		return (oldhash + 1) % size

	def get(self, key):
		startslot = self.hashfunction(key, len(self.slots))

		data = None
		stop = False
		found = False
		position = startslot
		while self.slots[position] is (not None) and (not found) and (not stop):
			if self.slots[position] == key:
				found = True
				data = self.thash[position]
			else:
				position = self.rehash(position, len(self.slots))
				if position == startslot:
					stop = True
		return data

	def __getitem__(self, key):
		return self.get(key)

	def __setitem__(self, key, newhash):
		self.add(key, newhash)

	def printTable(self):
		print('HashTable', len(self.slots), self.collisions)
		for i in range(len(self.slots)):
			if self.slots[i]:
				print(self.slots[i], self.count[i])
