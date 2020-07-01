#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <string>

using namespace std;


bool binsearch(vector<int>& v, int value, int& m, int from, int to)
{
	int mid = (from + to) / 2;
	if (value == v[mid]) { m = mid;  return true; }
	if (from == to) { m = mid; return false; }
	else if (value < v[mid])
	{
		return binsearch(v, value, m, from, mid);
	}
	else
	{
		return binsearch(v, value, m, mid + 1, v.size() - 1);
	}
}

bool bin_search(vector<int>& v, int value, int& m)
{
	int mid = (v.size() / 2) - 1;

	if (value == v[mid])
	{			
		m = mid;
		return true;
	}		
	else if(value > v[mid])
	{			
		return binsearch(v, value, m, mid + 1, v.size()-1);
	}
	else
	{
		return binsearch(v, value, m, 0, mid);
	}
	
	
}




int main()
{
	ifstream data;
	vector<int> vec;
	int in;
	data.open(DATA_FILE);
	while (data >> in)
	{
		vec.push_back(in);
	}
	cout << "Before sorting: " << endl;
	for (int i = 0; i < vec.size(); i++)
	{
		cout << vec[i] << " ";
	}
	cout << endl;
	sort(vec.begin(), vec.end());
	cout << "After sorting: " << endl;
	for (int j = 0; j < vec.size(); j++)
	{
		cout << vec[j] << " ";
	}
	char resp;
	int out;
	int k = 0;
	string input;
	while (true)
	{
		cout << endl << "Enter a value: ";
		getline(cin, input);
		in = stoi(input);
		if (bin_search(vec, in, out))
		{
			cout << "Found. m=" << out << endl;
		}
		else
		{
			cout << "Not found. m=" << out << endl;
		}

		cout << "Continue (y/n)? ";
		resp = cin.get();
		cin.ignore();
		if (resp == 'n') break;
	}
	


	return 0;
}
