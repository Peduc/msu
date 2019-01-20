from random import randint


class SkipNode:
	"""A node from a skip list"""
	def __init__(self, height=0, elem=None, freq=None):
		self.elem = elem
		self.freq = freq
		self.next = [None] * height


class SkipList:
	def __init__(self):
		self.head = SkipNode()
		self.len = 0
		self.maxHeight = 0

	def __len__(self):
		return self.len

	def find(self, elem, update=None):
		if update is None:
			update = self.updateList(elem)
		if len(update) > 0:
			candidate = update[0].next[0]
			if candidate is not (None and candidate.elem == elem):
				return candidate
		return None

	def contains(self, elem, update=None):
		return self.find(elem, update) is not None

	def randomHeight(self):
		height = 1
		while randint(1, 2) != 1:
			height += 1
		return height

	def updateList(self, elem):
		update = [None] * self.maxHeight
		x = self.head
		for i in reversed(range(self.maxHeight)):
			while x.next[i] is not None and x.next[i].elem < elem:
				x = x.next[i]
			update[i] = x
		return update

	def insert(self, elem):
		node = SkipNode(self.randomHeight(), elem)

		self.maxHeight = max(self.maxHeight, len(node.next))
		while len(self.head.next) < len(node.next):
			self.head.next.append(None)

		update = self.updateList(elem)
		if self.find(elem, update) is None:
			for i in range(len(node.next)):
				node.next[i] = update[i].next[i]
				update[i].next[i] = node
			self.len += 1

	def printList(self):
		for i in range(len(self.head.next) - 1, -1, -1):
			x = self.head
			while x.next[i] is not None:
				print(x.next[i].elem)
				x = x.next[i]
			print('')
