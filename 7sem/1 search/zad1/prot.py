import matplotlib.pyplot as plt
import rk
import bf


def TextCreation(Alphabet,TextLen,SubLength):
	from random import randint
	# Files:
	# Source:
	f0 = open("text.txt", "w")
	for n in range (0,TextLen):
		# for n in range (0,10*pow(2,TextPower)):
		f0.write(Alphabet[randint(0, 3)])
	f0.close()
	# Sequence:
	f1 = open("sequence.txt", "w")
	for n in range (0,SubLength):
		f1.write(Alphabet[randint(0, 3)])
	f1.close()


def SubCreation(Alphabet,SubLen):
	from random import randint
	# Files:
	# Sequence:
	f1 = open("sequence.txt", "w")
	for n in range (SubLength):
		f1.write(Alphabet[randint(0, len(Alphabet)-1)])
	f1.close()


res_t_bf=[]
res_t_rk=[]
res_s_bf=[]
res_s_rk=[]
#Input data:
Alphabet="AGTC"
MinTextLength=1000
MaxTextLength=100000
TextStep=10000

MinSubLength=4
MaxSubLength=128
SubStep=16

SubLength=4
x_t=[]
x_s=[]
# First part
for n in range(MinTextLength, MaxTextLength, TextStep):
	# for n in range(1,10*pow(2, TextPower)):
	x_t += [n]
	TextCreation(Alphabet, n, SubLength)
	t0 = open("text.txt", "r")
	text = t0.read()
	s0 = open("sequence.txt", "r")
	seq = s0.read()
	res_t_bf = res_t_bf+[bf.BruteForce(text,seq)]
	res_t_rk = res_t_rk+[rk.RabinKarp(text,seq, 207, 13)]
	t0.close()
	s0.close()
	print("%.4f" % (100*n/MaxTextLength))

# Second part
for n in range(MinSubLength,MaxSubLength,SubStep):
	x_s += [n]
	# print(pow(2,n))
	SubCreation(Alphabet,n)
	s0 = open("sequence.txt", "r")
	seq = s0.read()
	res_s_bf = res_s_bf+[bf.BruteForce(text, seq)]
	res_s_rk = res_s_rk+[rk.RabinKarp(text, seq, 207, 13)]
	s0.close()
# print("%.4f" % (100*n/TextPower))

#Comparison of counters
plt.subplot(211)
line_10,line_20 = plt.plot(x_t,res_t_bf,'bD:', x_t, res_t_rk, 'r^:')
# plt.semilogx() 
# plt.semilogy()
# plt.title('Task 1')
plt.xlabel('Length of text')
plt.ylabel('Number of operations')
plt.legend( (line_10, line_20), (u'Brute Force', u'Rabin-Karp'), loc = 'best')
plt.grid()
# plt.savefig('plot.png')
plt.subplot(212)
line_11,line_21 = plt.plot(x_s,res_s_bf,'bD:', x_s, res_s_rk, 'r^:')
# plt.title('Task 1')
plt.xlabel('Length of subsequence')
plt.ylabel('Number of operations')
plt.legend( (line_11, line_21), (u'Brute Force', u'Rabin-Karp'), loc = 'best')
plt.grid()
plt.show()

input('Press ENTER to exit')
