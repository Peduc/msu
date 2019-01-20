def SeqCreation(Length, MaxVal):
	from random import randint
	result=[]
	for i in range(0,Length):
		result=result+[randint(0,MaxVal)]
	return result

import matplotlib.pyplot as plt
import shkr
import slct
import slct_unst

# Input data:
MaxVal=20
MinLength=10
MaxLength=10000
Step=1000
x=[]
comp_s=[]
comp_su=[]
comp_c=[]

trans_s=[]
trans_su=[]
trans_c=[]
# First part
for i in range(MinLength,MaxLength,Step):
	x+=[i]
	seq=SeqCreation(i,MaxVal)
	# seq_s=seq.copy()
	seq_c=seq.copy()
	seq_su=seq.copy()
	res_comp_c,res_trans_c=shkr.Cocktail(seq_c)
	# res_comp_s,res_trans_s=slct.SelectSort(seq_s)
	res_comp_su,res_trans_su=slct_unst.selection_sort(seq_su)
	
	comp_c+=[res_comp_c]
	# comp_s+=[res_comp_s]
	comp_su+=[res_comp_su]
	trans_c+=[res_trans_c]
	# trans_s+=[res_trans_s]
	trans_su+=[res_trans_su]
	# print(trans_su)	
	seq=[]	
	# res_s=res_s+[slct.SelectSort(seq_s)]
	print("%.2f" % (100*i/MaxLength))


#Comparison of counters
plt.subplot()
line_10,line_20,line_30,line_40 = plt.plot(x,comp_su,'bD:', x, comp_c, 'r^:',x,trans_su,'kD:', x, trans_c, 'm^:')
# plt.semilogy() 
# plt.semilogx() 
# plt.title('Task 1')
plt.xlabel('Length of sequence')
plt.ylabel('Number of operations') 
plt.legend( (line_10, line_20,line_30,line_40), (u'Select_comp', u'Cocktail_comp', u'Select_trans', u'Cocktail_trans'), loc = 'best')

plt.grid()
plt.show()

input('Press ENTER to exit')