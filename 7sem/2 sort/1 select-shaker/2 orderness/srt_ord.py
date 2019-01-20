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
import bubble

#Input data:
MaxVal=20
MaxLength=200
x=[]
res_s=[]
res_c=[]
# seq_next_s=[]
seq_next_c=[]
seq_next_su=[]
# seq_c=[]
seq_s=[]
seq_su=[]
# comp_s=[]
comp_su=[]
comp_c=[]

# trans_s=[]
trans_su=[]
trans_c=[]

# First part
seq_init=SeqCreation(MaxLength,MaxVal)
# print(seq_init,'initial sequence')

for i in range(-MaxLength+1, MaxLength):
	x+=[i/MaxLength]
	comp_c+=[0]
	comp_su+=[0]
	trans_c+=[0]
	trans_su+=[0]
	
print(x[2*(MaxLength-1)])
print(x[MaxLength-1])

for i in range(0,MaxLength):
	if (i==0):
		seq_init_c=seq_init.copy()
		seq_init_su=seq_init.copy()
		
		res_comp_c,res_trans_c=shkr.Cocktail(seq_init_c)
		res_comp_su,res_trans_su=slct_unst.selection_sort(seq_init_su)
	
		comp_c[MaxLength-1]=res_comp_c
		comp_su[MaxLength-1]=res_comp_su
		
		trans_c[MaxLength-1]=res_trans_c
		trans_su[MaxLength-1]=res_trans_su
	else:
		seq_init_c_b=seq_init.copy()
		seq_init_su_b=seq_init.copy()
		seq_init_c_s=seq_init.copy()
		seq_init_su_s=seq_init.copy()		
		# Bubbled array
		seq_c_b=bubble.BubbleSingleSort(seq_init_c_b,i)
		seq_su_b=bubble.BubbleSingleSort(seq_init_su_b,i)
		# Stoned array
		seq_c_s=bubble.StoneSingleSort(seq_init_c_s,i)
		seq_su_s=bubble.StoneSingleSort(seq_init_su_s,i)		
		# Bubbled result
		res_comp_c,res_trans_c=shkr.Cocktail(seq_c_b)
		res_comp_su,res_trans_su=slct_unst.selection_sort(seq_su_b)
		# Add bubble to results' array
		comp_c[MaxLength-1+i]=res_comp_c
		comp_su[MaxLength-1+i]=res_comp_su
		
		trans_c[MaxLength-1+i]=res_trans_c
		trans_su[MaxLength-1+i]=res_trans_su
		# Stoned result
		res_comp_c,res_trans_c=shkr.Cocktail(seq_c_s)
		res_comp_su,res_trans_su=slct_unst.selection_sort(seq_su_s)
		# Add stone to results' array
		comp_c[MaxLength-1-i]=res_comp_c
		comp_su[MaxLength-1-i]=res_comp_su
		
		trans_c[MaxLength-1-i]=res_trans_c
		trans_su[MaxLength-1-i]=res_trans_su
	print("%.2f" % (100*i/MaxLength))
# print(count_c)
# print(count_s)
# print(count_su)	

#Comparison of counters
plt.subplot()
line_10,line_20,line_30,line_40 = plt.plot(x,comp_su,'bD:', x, comp_c, 'r^:',x,trans_su,'k,:', x, trans_c, 'm,:')
# plt.semilogy() 
# plt.semilogx() 
# plt.title('Task 2')
plt.xlabel('Orderness')
plt.ylabel('Number of operations') 
plt.legend( (line_10, line_20,line_30,line_40), (u'Select_comp', u'Cocktail_comp', u'Select_trans', u'Cocktail_trans'), loc = 'best')

plt.grid()
plt.show()

input('Press ENTER to exit')