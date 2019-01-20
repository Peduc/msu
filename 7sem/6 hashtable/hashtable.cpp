// уникальных слов 43 865
// +25% = 54 832
// ближайшее простое число 54 833

const long h_size = 18397;

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <utility>
//#include <list>
//#include <vector>
#include <limits.h>

using namespace std;

#define B1 sizeof(int)*CHAR_BIT
#define TQ (int)((B1*3)/4)
#define OE (int)(B1/8)
#define HB ~((unsigned)(~NULL)>>OE)

unsigned long HashPJW(const char* s) {
	unsigned long hv, i;
	for (hv = 0; *s; s++) {
		hv = (hv << OE) + *s;
		if ((i == hv) && (HB != 0))
			hv = (hv ^ (i >> TQ))&~HB;
	}
	return hv;
}

unsigned long MFCHash(const char* s) {
	unsigned long nHash = 0;
	while (*s)
		nHash = (nHash << 5) + nHash + *s++;
	return nHash;
}

class list1
{
public:

	class Node
	{
	public:
		Node* pNext;
		pair< string, long > data;

		Node(pair< string, long > data, Node *pNext = nullptr)
		{
			this->data = data;
			this->pNext = pNext;
		}
	};

	Node *head;

	list1()
	{
		head = nullptr;
	}


	int insert(string s)
	{
		if (head == nullptr)
		{
			pair< string, long > t(s, 1);
			head = new Node(t);
			return 0;
		}
		else
		{
			Node* current = this->head;
			Node* last;
			while ((current != nullptr) && (current->data.first != s))
			{
				last = current;
				current = current->pNext;
			}
			if (current != nullptr) { current->data.second++; }
			else
			{
				pair< string, long > t(s, 1);
				last->pNext = new Node(t);
			}
			return 1;
		}
	}

	void show() {
		Node* current = this->head;

		while (current != nullptr)
		{
			cout << current->data.first << ' ' << current->data.second << endl;
			current = current->pNext;
		}

	}

};

class hesh {
public:
	//list<pair<string, long>> a[h_size];
	list1 a[h_size];
	long n_col;
	long n_zap;

	hesh() {
		//for (long i = 0; i < h_size; i++) {
		//	a[i].clear();
		//}
		n_col = 0;
		n_zap = 0;
	}

	void insert(string s, long long n) {

		long p = n % h_size;
		if (a[p].insert(s)==0) n_zap++;
		else n_col++;
		
	}

	pair<long, long> show() {
		return make_pair(n_zap, n_col);
	}

	//~hesh() {

	//	delete[] a;

	//}

};





void main()
{
	string word;
	hesh a;
	hesh b;



	ifstream text("text.txt");
	ofstream myfile;
	myfile.open("task_7.csv");


	while ((text >> word))
	{
	
		const char* str = word.c_str();
		size_t str_hash = hash<string>{}(word);
	
		a.insert(word, HashPJW(str));
		b.insert(word, MFCHash(str));
		myfile << a.show().first << ';' << a.show().second << ';'<<b.show().first << ';' << b.show().second << "\n";

			
	}


	text.close();
	myfile.close();

	system("pause");

}

