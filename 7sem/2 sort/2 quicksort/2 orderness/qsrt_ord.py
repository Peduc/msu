import matplotlib.pyplot as plt
import numpy as np
import qsr
import qsi
import timeit
import bubble

def SeqCreation(Length, MaxVal):
	from random import randint
	result=[]
	for i in range(0,Length):
		result=result+[randint(0,MaxVal)]
	return result

def PltCreation (xaxis,y1axis,y2axis,logx,logy):
	plt.subplot()
	line_10,line_20 = plt.plot(xaxis,y1axis,'b,:', xaxis, y2axis, 'r,:')
	if logx==1:
		plt.semilogx() 
	if logy==1:
		plt.semilogy() 	
	# plt.title('Task 3')
	plt.xlabel('Orderness')
	plt.ylabel('Number of operations') 
	plt.legend( (line_10, line_20), (u'Iterative', u'Recurence'), loc = 'best')
	plt.grid()
	plt.show()
	
def Main():	
	#Input data:
	MaxVal=20
	MaxLength=100
	repeats=10
	
	x=[]
	time_i=[]
	time_r=[]
	time_i_s=[]
	time_r_s=[]
	time_i_b=[]
	time_r_b=[]
	
	seq_next_r=[]
	seq_next_i=[]

	seq_r=[]
	seq_i=[]
		
	delta_time_r=[]
	delta_time_i=[]

	# First part
	seq_init=SeqCreation(MaxLength,MaxVal)
	
	for i in range(-MaxLength+1, MaxLength):
		x+=[i/MaxLength]
		delta_time_r+=[0]
		delta_time_i+=[0]

	for i in range(0,MaxLength):
		if (i==0):
			time_r=0
			time_i=0
			for j in range(0,repeats):
				seq_init_r=seq_init.copy()
				seq_init_i=seq_init.copy()
		
				start_time = timeit.default_timer()
				qsr.quickSort(seq_init_r,0,len(seq_init_r)-1)
				time_r+=(timeit.default_timer() - start_time)
			
				start_time = timeit.default_timer()
				qsi.quickSortIterative(seq_init_i,0,len(seq_init_i)-1)
				time_i+=(timeit.default_timer() - start_time)
			delta_time_r[MaxLength-1]=time_r/repeats
			delta_time_i[MaxLength-1]=time_i/repeats		
		else:
			time_r=0
			time_i=0
			time_i_s=0
			time_r_s=0
			time_i_b=0
			time_r_b=0				
			for j in range(0,repeats):
				seq_init_r_b=seq_init.copy()
				seq_init_i_b=seq_init.copy()
				seq_init_r_s=seq_init.copy()
				seq_init_i_s=seq_init.copy()			
				
				# Bubbled array
				seq_r_b=bubble.BubbleSingleSort(seq_init_r_b,i)
				seq_i_b=bubble.BubbleSingleSort(seq_init_i_b,i)
				
				# Stoned array
				seq_r_s=bubble.StoneSingleSort(seq_init_r_s,i)
				seq_i_s=bubble.StoneSingleSort(seq_init_i_s,i)		
				
				# Bubbled result
				start_time = timeit.default_timer()
				qsr.quickSort(seq_r_b,0,len(seq_r_b)-1)
				time_r_b+=(timeit.default_timer() - start_time)
			
				start_time = timeit.default_timer()
				qsi.quickSortIterative(seq_i_b,0,len(seq_i_b)-1)
				time_i_b+=(timeit.default_timer() - start_time)
		
				# Stoned result
				start_time = timeit.default_timer()
				qsr.quickSort(seq_r_s,0,len(seq_r_s)-1)
				time_r_s+=(timeit.default_timer() - start_time)
			
				start_time = timeit.default_timer()
				qsi.quickSortIterative(seq_i_s,0,len(seq_i_s)-1)
				time_i_s+=(timeit.default_timer() - start_time)
			# Adding results to array
			delta_time_r[MaxLength-1-i]=time_r_s/repeats
			delta_time_i[MaxLength-1-i]=time_i_s/repeats			
			delta_time_r[MaxLength-1+i]=time_r_b/repeats
			delta_time_i[MaxLength-1+i]=time_i_b/repeats
		print("%.2f" % (100*i/MaxLength))	
	
	PltCreation(x,delta_time_i,delta_time_r,0,0)
	input('Press ENTER to exit')
try:
	Main()
	# raw_input()	
except Exception as ex:
    print (ex)
    input('Error')	