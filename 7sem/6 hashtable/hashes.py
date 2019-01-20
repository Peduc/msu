import matplotlib.pyplot as plt
import hashlib
import hashtable as ht
import hashtable2 as ht2


def PJWHash(key):
	seq = key[0]
	# Need large number
	BitsInUnsignedInt = 4*8
	ThreeQuarters = int((BitsInUnsignedInt * 3) / 4)
	OneEighth = int(BitsInUnsignedInt / 8)
	HighBits = (0xFFFFFFFF) << (BitsInUnsignedInt - OneEighth)
	pHash = 0
	test = 0

	for char in seq:
		pHash = (pHash << OneEighth) + ord(char)
	test = pHash & HighBits
	if test != 0:
		pHash = ((pHash ^ (test >> ThreeQuarters)) & (~HighBits))
	return (pHash & 0x7FFFFFFF)


def MFCHash(key):
	# large prime number to initialize
	seq = key[0]
	mHash = 0
	# mHash = 5381
	# mHasht = 0
	for char in seq:
		# print(char)
		mHash = (mHash << 5) + mHash + ord(char)
		# mHasht = (mHash*33) % (2**32)
		# mHash = (mHasht+ord(char)) % (2**32)
	return mHash


def Hash37(key):
	# large prime number to initialize
	seq = key[0]
	trHash = 0
	for char in seq:
		trHash = 37*trHash + ord(char)
	return trHash


def MD5Hash(key, bits):
	seq = key[0]
	# print(seq)
	mdhash = hashlib.md5(seq.encode())
	hex_res = mdhash.hexdigest()
	short_res = hex_res[0:int(bits/4)]
	return int(short_res, 16)


def PltCreation(yname, xaxis, y1axis, y2axis, logx, logy):
	plt.subplot()
	line_10, line_20 = plt.plot(xaxis, y1axis, 'b,:', xaxis, y2axis, 'r,:')
	if logx == 1:
		plt.semilogx()
	if logy == 1:
		plt.semilogy()
	plt.title('MFC (DJB2) and PJW hashes')
	plt.xlabel('Occupancy')
	if yname == 'Chain':
		plt.ylabel('Chain size')
	else:
		plt.ylabel('Number of collisions')
	plt.legend((line_10, line_20), (u'PJW', u'MFC (DJB2)'), loc='best')
	plt.grid()
	plt.show()


def PltCreation3(yname, xaxis, y1axis, y2axis, y3axis, logx, logy):
	plt.subplot()
	line_10, line_20, line_30 = plt.plot(xaxis, y1axis, 'b,:', xaxis, y2axis, 'r,:', xaxis, y3axis, 'm,:')
	if logx == 1:
		plt.semilogx()
	if logy == 1:
		plt.semilogy()
	plt.title('MFC (DJB2), PJW and MD5 hashes')
	plt.xlabel('Occupancy')
	if yname == 'Chain':
		plt.ylabel('Chain size')
	else:
		plt.ylabel('Number of collisions')

	plt.legend((line_10, line_20, line_30), (u'PJW', u'MFC (DJB2)', u'MD5'), loc='best')
	plt.grid()
	plt.show()


def textPrep():
	f0 = open("atlas.txt", "r")
	text_initial = f0.read()
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
	# f1 = open("text_wnp.txt", "w")
	for count in range(len(text_clear)):
		f1.write("%s\n" % text_clear[count])
	f1.close()


textPrep()
arr_in = []
with open("text.txt") as file:
	for line in file:
		new_line = line.lower().split()
		arr_in += [new_line]

MaxRange = len(arr_in)
# MaxRange = 20

# Exact number of unique words is 22156
h_size = 22157
# 0,85 PJW is better
# h_size = 97
# 1
# h_size = 3757
# 1
# h_size = 7357

PJWHashTable = ht2.HashTable(h_size)
MFCHashTable = ht2.HashTable(h_size)
MD5HashTable = ht2.HashTable(h_size)

res_pjw = []
res_mfc = []
res_md5 = []

for i in range(MaxRange):
	res_pjw.append(PJWHashTable.add(arr_in[i], PJWHash(arr_in[i])))
	res_mfc.append(MFCHashTable.add(arr_in[i], MFCHash(arr_in[i])))
	res_md5.append(MD5HashTable.add(arr_in[i], MD5Hash(arr_in[i], 32)))
	if ((100 * (i+1) / MaxRange) % 10) == 0:
		print("%.0f" % (100 * (i+1) / MaxRange), '%')

# print('PJW:', res_pjw[len(res_pjw)-1][1], 'MFC (DJB2):', res_mfc[len(res_mfc)-1][1], 'MD5:', res_md5[len(res_md5)-1][1])
# print('PJW:', res_pjw[len(res_pjw)-1][1], 'MFC (DJB2):', res_mfc[len(res_mfc)-1][1])

x = [item[0] for item in res_pjw]
pl = 1
y_pjw = [item[pl] for item in res_pjw]
y_mfc = [item[pl] for item in res_mfc]
y_md5 = [item[pl] for item in res_md5]

PltCreation('Chain1', x, y_pjw, y_mfc, 0, 0)
# PltCreation(x, y_mfc, y_md5, 0, 0)
# PltCreation3('Chain', x, y_pjw, y_mfc, y_md5, 0, 0)
