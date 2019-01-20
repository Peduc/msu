class Node:
	def __init__(self):
		self.key = None
		self.freq = 1
		self.next = None

		self.ops = 0
		self.len = 0


class LinkedList:
	def __init__(self):
		self.head = None
		self.len = 0

	def __len__(self):
		return self.len

	def insert(self, key):
		ops = 0
		flag = False
		curr = self.head
		if curr is None:
			n = Node()
			n.key = key
			self.head = n
			self.len += 1
			n.ops = 0
			n.len += 1
			# flag = False
			return

		while curr.next is not None:
			ops += 1
			if curr.next.key == key:
				curr.next.freq += 1
				flag = True
				break
			if curr.next.key > key:
				flag = False
				break
			curr = curr.next
		if flag is False:
			n = Node()
			n.key = key
			n.next = curr.next
			curr.next = n
			self.len += 1
			n.len = self.len
			n.ops = ops+1
		return

	def printList(self):
		print("\n*****Alphabetical List******")
		curr = self.head
		while curr is not None:
			print('Word:', curr.key, 'Frequency:', curr.freq, 'Operations:', curr.ops, 'Length:', curr.len)
			curr = curr.next

	def printOps(self):
		# print("\n*****Ops by Length in Linked List******")
		curr = self.head
		result = []
		# print(sorted(self, curr.len))
		while curr is not None:
			result.append((curr.ops, curr.len))
			# print('Operations:', curr.ops, 'Length:', curr.len)
			curr = curr.next
		return sorted(result, key=lambda x: x[1])
