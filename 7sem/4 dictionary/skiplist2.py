import random


class Node(object):
	"""	Class to implement node	"""

	def __init__(self, key, level):
		self.key = key
		self.freq = 1
		# list to hold references to node of different level
		self.forward = [None] * (level + 1)

		self.ops = 0
		self.len = 0


class SkipList(object):
	""" Class for Skip list """

	def __init__(self, max_lvl, P):
		# Maximum level for this skip list
		self.MAXLVL = max_lvl

		# P is the fraction of the nodes with level
		# i references also having level i+1 references
		self.P = P

		# create header node and initialize key to -1
		self.header = self.createNode(self.MAXLVL, -1)

		# current level of skip list
		self.level = 0

		self.len = 0

	def __len__(self):
		return self.len

	# create  new node
	def createNode(self, lvl, key):
		n = Node(key, lvl)
		return n

	# create random level for node
	def randomLevel(self):
		lvl = 0
		while random.random() < self.P and lvl < self.MAXLVL:
			lvl += 1
		return lvl

	# insert given key in skip list
	def insert(self, key):
		# create update array and initialize it
		update = [None] * (self.MAXLVL + 1)
		current = self.header
		ops = 0
		"""	
		start from highest level of skip list 
		move the current reference forward while key  
		is greater than key of node next to current 
		Otherwise inserted current in update and  
		move one level down and continue search 
		"""

		for i in range(self.level, -1, -1):
			ops += 1
			while current.forward[i] and current.forward[i].key < key:
				current = current.forward[i]
			update[i] = current

		"""  
		reached level 0 and forward reference to  
		right, which is desired position to  
		insert key 
		"""
		current = current.forward[0]

		""" 
		if current is NULL that means we have reached 
		to end of the level or current's key is not equal 
		to key to insert that means we have to insert 
		node between update[0] and current node 
		"""
		if (current is None) or (current.key != key):
			# Generate a random level for node
			rlevel = self.randomLevel()

			""" 
			If random level is greater than list's current 
			level (node with highest level inserted in  
			list so far), initialize update value with reference 
			to header for further use 
			"""
			if rlevel > self.level:
				for i in range(self.level + 1, rlevel + 1):
					update[i] = self.header
				self.level = rlevel

			# create new node with random level generated
			n = self.createNode(rlevel, key)

			# insert node by rearranging references
			for i in range(rlevel + 1):
				n.forward[i] = update[i].forward[i]
				update[i].forward[i] = n

			self.len += 1
			n.len = self.len
			n.ops = ops
			# print("Successfully inserted key {}".format(key))
		else:
			# print(key, 'repeated', current.key)
			current.freq += 1

		# Display skip list level wise

	def printList(self):
		print("\n*****Skip List******")
		head = self.header
		for lvl in range(self.level + 1):
			if lvl == 0:
				print("Level {}: ".format(lvl), end=" ")
				print("")
				node = head.forward[lvl]
				while node is not None:
					print('Word:', node.key, 'Frequency:', node.freq)
					node = node.forward[lvl]
					# print("")

	def printOps(self):
		# print("\n*****Ops by Length in Skip List******")
		head = self.header
		node = head.forward[0]
		result = []
		# print(sorted(self, curr.len))
		while node is not None:
			result.append((node.ops, node.len))
			# print('Operations:', curr.ops, 'Length:', curr.len)
			node = node.forward[0]
		return sorted(result, key=lambda x: x[1])
