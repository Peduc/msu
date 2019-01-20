import matplotlib.pyplot as plt
import qsr
import qsi
import timeit
import sys

def SeqCreation(Length, MaxVal):
	from random import randint
	result = []
	for i in range(0, Length):
		result = result+[randint(0, MaxVal)]
	return result

def PltCreation (xaxis,y1axis,y2axis,logx,logy):
	plt.subplot()
	line_10, line_20 = plt.plot(xaxis, y1axis, 'b.:', xaxis, y2axis, 'r.:')
	if logx == 1:
		plt.semilogx() 
	if logy == 1:
		plt.semilogy() 	
	plt.title('Recursive and Iterative QuickSort')
	plt.xlabel('Length of array')
	plt.ylabel('Consumed time') 
	plt.legend((line_10, line_20), (u'Iterative', u'Recurence'), loc = 'best')
	plt.grid()
	plt.show()
	
def Main():	
	sys.setrecursionlimit(40000000)
	# Input data:
	MaxVal = 20
	MinLength = 1000
	MaxLength = 90000
	TextStep = 20000
	repeats = 3
	x = []
	res_i = []
	res_r = []
	count_r = []
	count_i = []
	Theor=[]
	delta_time_i = []
	delta_time_r = []
	# First part
	for i in range(MinLength, MaxLength+1, TextStep):
		x += [i]
		seq_init = SeqCreation(i, MaxVal)
		time_r = 0
		time_i = 0
		for j in range(0, repeats):
			seq_r = seq_init.copy()
			seq_i = seq_init.copy()
		
			start_time = timeit.default_timer()
			qsr.quickSort(seq_r, 0, len(seq_r)-1)
			time_r += (timeit.default_timer() - start_time)
		
			start_time = timeit.default_timer()
			qsi.quickSortIterative(seq_i, 0, len(seq_i)-1)
			time_i += (timeit.default_timer() - start_time)
		
		delta_time_r += [time_r/repeats]
		delta_time_i += [time_i/repeats]
		
		seq_init = []
		print("%.1f" % (100*i/MaxLength))	
	
	PltCreation(x, delta_time_i, delta_time_r, 0, 0)
	input('Press ENTER to exit')


try:
	Main()
except Exception as ex:
	print(ex)
	input('Error')