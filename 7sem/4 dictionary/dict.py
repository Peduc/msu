import matplotlib.pyplot as plt
import scipy as sp
import numpy as np
import skiplist2 as sl2
import linkedlist as ll


def PltCreation(xaxis, y1axis, y1taxis, y2axis, logx, logy):
	plt.subplot()
	line_10, line_20, line_30 = plt.plot(xaxis, y1axis, 'b,:', xaxis, y1taxis, 'm.:', xaxis, y2axis, 'r.:')
	if logx == 1:
		plt.semilogx()
	if logy == 1:
		plt.semilogy()
	plt.title('Singly-Linked List and Skip List ')
	plt.xlabel('Length of container')
	plt.ylabel('Number of comparisons')
	plt.legend((line_10, line_20, line_30), (u'Singly-Linked', u'Singly-Linked Average', u'Skip'), loc='best')
	plt.grid()
	plt.show()

def textPrep():
	import re
	f0 = open("atlas.txt", "r")
	text_initial = f0.read()
	# text_clear = re.split('[., ]+', text_initial)
	text_clear = text_initial.replace('.', '').replace(',', '')\
		.replace('(', '').replace(')', '').replace('«', '').replace('»', '')\
		.replace('@', '').replace('-', '').replace(':', '').replace(';', '')\
		.replace('"', '').replace('!', '').replace('?', '').replace('—', '')\
		.replace('_', '').replace(']', '').replace('[', '').replace('*', '')\
		.replace('“', '').replace('”', '').replace('‘', '').replace('’', '')\
		.replace('0', '').replace('1', '').replace('2', '').replace('3', '')\
		.replace('4', '').replace('5', '').replace('6', '').replace('7', '')\
		.replace('8', '').replace('9', '').split()

	f1 = open("text.txt", "w")
	for count in range(len(text_clear)):
		f1.write("%s\n" % text_clear[count])
	f1.close()


# textPrep()
arr_in = []
with open("text.txt") as file:
	for line in file:
		new_line = line.lower().split()
		arr_in += [new_line]

# MaxRange = len(arr_in)
MaxRange = 10000
MaxLevelSL = int(round(np.log2(MaxRange)))
# print(int(round(np.log2(MaxRange))))
res_link = ll.LinkedList()
res_skip = sl2.SkipList(MaxLevelSL, 0.5)

for i in range(MaxRange):
	res_link.insert(arr_in[i])
	res_skip.insert(arr_in[i])
	if ((100 * (i+1) / MaxRange) % 10) == 0:
		print("%.0f" % (100 * (i+1) / MaxRange), '%')

# print('Length of linked:', len(res_link))
# print('Length of Skip:', len(res_skip))

x = [item[1] for item in res_link.printOps()]
y1 = [item[0] for item in res_link.printOps()]
y1_av_parameters = sp.polyfit(x, y1, 1)
y1_av_pol = sp.poly1d(y1_av_parameters)
y2 = [item[0] for item in res_skip.printOps()]

# print(len(x), len(y1), len(y2))

if MaxRange == len(arr_in):
	index = len(x)-1
	del x[index]
	del y1[index]

PltCreation(x, y1, y1_av_pol(x), y2, 0, 0)

input('Press ESKETIT to exit')
