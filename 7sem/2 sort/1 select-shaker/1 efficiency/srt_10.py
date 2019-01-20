def SeqCreation(Power, MaxVal):
	from random import randint
	result=[]
	for i in range(0,pow(10,Power)):
		result=result+[randint(0,MaxVal)]
	return result

import matplotlib.pyplot as plt
import shkr
import slct
# import slct_unst

#Input data:
MaxVal=20
MaxPower=3
x=[]
res_s=[]
res_c=[]
# First part
for i in range(1,MaxPower+1):
	x=x+[pow(10,i)]
	seq=SeqCreation(i,MaxVal)
	seq1=seq
	res_c=res_c+[shkr.Cocktail(seq1)]
	res_s=res_s+[slct.SelectSort(seq)]
	# res_s=res_s+[slct_unst.selection_sort(seq)]	
	seq=[]	
	seq1=[]
	# res_s=res_s+[slct.SelectSort(seq_s)]
	print("%.2f" % (100*i/MaxPower))


print(res_c)
print(res_s)

#Comparison of counters
plt.subplot()
line_10,line_20 = plt.plot(x,res_s,'bD:', x, res_c, 'r^:')
# plt.semilogy() 
# plt.semilogx() 
# plt.title('Task 1')
plt.xlabel('Length of sequence')
plt.ylabel('Number of operations') 
plt.legend( (line_10, line_20), (u'Select', u'Cocktail'), loc = 'best')

plt.grid()
plt.show()

input('Press ENTER to exit')