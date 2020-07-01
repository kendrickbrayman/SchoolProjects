#include <iostream>
#include <vector>
#include <iomanip>
#include <assert.h>
#include <utility>
#include <string>
#include <fstream>
#include <sstream>

using namespace std;

class Matrix
{
	public:
	//nickname for the data type storing size of the vector
	typedef vector<double>::size_type size_type;
	//nickname for vector<double>
	typedef vector<double> Vector;
	 // constructors
	Matrix() {}; // empty matrix
	Matrix(size_type n, size_type m, double val = 0.0); // n x m matrix
	Matrix(const Vector & v); // matrix n x 1 derived from Vector
	//operator() for getting Matrix (i,j) value
	double operator()(size_type i, size_type j) const;
	 //operator() for setting Matrix (i,j) value
	double & operator()(size_type i, size_type j);
	 //operator*:
	Matrix operator*(double c) const; // Matrix*constant
	vector<double> operator*(const vector<double> &v) const; // Matrix*Vector
	Matrix operator*(const Matrix & B) const; //Matrix*Matrix
	//operator+:
	Matrix operator+(const Matrix & B) const;//Matrix+Matrix
	Matrix operator-(const Matrix & B) const;//Matrix-Matrix
	Matrix operator-() const;// -Matrix
	//matrix size getters (2 alternatives):
	pair< size_type, size_type > size() const; // returns std::pair
	void size(size_type & n, size_type & m) const; //size is set in n, m
	 //printing the matrix as a table:
	//Here width and prec are formatting parameters used for the input.
	//width is used in cout << setw(bw)
	//prec is used in cout << fixed << setprecision(prec)
	 //width=6 and prec = 2 are default values
	void print(unsigned short width = 6, unsigned short prec = 2) const;
	//returns true if the matrix is empty
	bool empty() const;
	 //resizing matrix to n x m
	void resize(size_type n, size_type m);
	//needed for overloading << operator which uses print()
	friend ostream & operator<<(ostream& os, const Matrix & A);
	private:
	vector< vector<double> > values; //2-d array storage of the matrix
};

Matrix::Matrix(size_type n, size_type m, double val)
{
	Vector nvec;
	for (int i = 0; i < n; ++i)
	{
		nvec.push_back(val);
	}
	for (int j = 0; j < m; ++j)
	{
		values.push_back(nvec);
	}
}

Matrix::Matrix(const Vector & v)
{
	values.push_back(v);
}

Matrix Matrix::operator*(double c) const
{
	Matrix out(values.size(),values[0].size());
	for (int i = 0; i < values.size();++i)
	{
		for (int j = 0; j < values[i].size(); ++j)
		{
			out(i, j) = c * values[i][j];
		}
	}
	return out;
}

double & Matrix::operator()(size_type i, size_type j)
{
	return values[i][j];
}

double Matrix::operator()(size_type i, size_type j) const
{
	return values[i][j];
}

vector<double> Matrix::operator*(const vector<double> &v) const
{
	Vector out;
	double sum = 0;
	for (int i = 0; i < values[0].size(); ++i)
	{
		for (int j = 0; j < values.size(); ++j)
		{
			sum += v[j] * values[j][i];
		}
		out.push_back(sum);
		sum = 0;
		
	}
	return out;
}

Matrix Matrix::operator*(const Matrix & B) const
{
	assert(values.size() == (B.values[0]).size());
	Matrix out;
	Vector vout;
	int sum = 0;
	for (int i = 0; i < (B.values).size(); ++i)
	{
		for (int j = 0; j < values[0].size(); ++j)
		{
			for (int k = 0; k < values.size(); ++k)
			{
				sum += values[j][k] * B.values[i][k];
			}
			vout.push_back(sum);
			sum = 0;
		}
		out.values.push_back(vout);
		vout.clear();
	}
	return out;
}

pair< vector<double>::size_type, vector<double>::size_type > Matrix::size() const
{
	pair<vector<double>::size_type, vector<double>::size_type> out;
	out.first = this->values[0].size();
	out.second = this->values.size();
	return out;
}

Matrix Matrix::operator+(const Matrix & B) const
{
	assert(this->size() == B.size());
	Matrix out(values[0].size(), values.size());
	for (int j = 0; j < values.size(); ++j)
	{
		for (int i = 0; i < values[0].size(); ++i)
		{
			out(i, j) = values[i][j] + (B.values)[i][j];
		}
	}
	return out;
}
Matrix Matrix::operator-(const Matrix & B) const
{
	assert(this->size() == B.size());
	Matrix out(values[0].size(), values.size());
	for (int j = 0; j < values.size(); ++j)
	{
		for (int i = 0; i < values[0].size(); ++i)
		{
			out(i, j) = values[i][j] - (B.values)[i][j];
		}
	}
	return out;
}

Matrix Matrix::operator-() const
{
	Matrix out(values[0].size(), values.size());
	for (int j = 0; j < values.size(); ++j)
	{
		for (int i = 0; i < values[0].size(); ++i)
		{
			out(i, j) = values[i][j] * -1;
		}
	}
	return out;
}

void Matrix::size(size_type & n, size_type & m) const
{
	n = this->values[0].size();
	m = this->values.size();
	return;
}

void Matrix::print(unsigned short width, unsigned short prec) const
{
	for (int i = 0; i < values[0].size(); ++i)
	{
		for (int j = 0; j < values.size(); ++j)
		{
			cout << fixed << setprecision(prec) << setw(width) << values[j][i];
		}
		cout << endl;
	}
}

bool Matrix::empty() const
{
	while (true)
	{
		for (int i = 0; i < values.size(); ++i)
		{
			for (int j = 0; j < values[0].size(); ++j)
			{
				if (values[i][j] != NULL) return false;
			}
		}
		break;
	}
	return true;
}

void Matrix::resize(size_type n, size_type m)
{
	if (values.size() == m && values[0].size() == n) return;
	values.resize(m);
	for (int i = 0; i < values.size(); ++i)
	{
		values[i].resize(n);
	}

}
ostream & operator<<(ostream& os, const Matrix & A)
{
	A.print();
	return os;
}

int main()
{
	string Adata, Bdata;
	ifstream DataA, DataB;
	int row = 0;
	int column = 0;
	string in1;
	string input,resp;
	while (true)
	{
		cout << "Enter the file name containing matrix A values: ";
		getline(cin, Adata);
		cout << endl << "Enter the file name containing matrix B values: ";
		getline(cin, Bdata);

		DataA.open(Adata);
		while (getline(DataA, input))
		{
			column = 0;
			stringstream s(input);
			while (getline(s, in1, ' '))
			{
				++column;
			}
			++row;
		}
		DataA.close();
		Matrix A(row, column);
		DataA.open(Adata);
		double in;
		row = 0;
		while (getline(DataA, input))
		{
			column = 0;
			stringstream s(input);
			while (s >> in)
			{
				A(column, row) = in;
				++column;
			}
			++row;
		}
		DataA.close();


		DataB.open(Bdata);
		row = 0;
		while (getline(DataB, input))
		{
			column = 0;
			stringstream s(input);
			while (getline(s, in1, ' '))
			{
				++column;
			}
			++row;
		}
		DataB.close();
		Matrix B(row, column);
		DataB.open(Bdata);
		row = 0;
		while (getline(DataB, input))
		{
			column = 0;
			stringstream s(input);
			while (s >> in)
			{
				B(column, row) = in;
				++column;
			}
			++row;
		}
		DataB.close();

		cout << "Printing A values: " << endl;
		A.print();
		cout << endl << "Printing B values: " << endl;
		B.print();
		Matrix S = A + B;
		cout << "____________________" << endl << "Computation of S = A + B" << endl << "____________________" << endl;
		S.print();
		Matrix D = A - B;
		cout << "____________________" << endl << "Computation of D = A - B" << endl << "____________________" << endl;
		D.print();
		Matrix P = A * B;
		cout << "____________________" << endl << "Computation of P = A * B" << endl << "____________________" << endl;
		P.print();
		cout << "____________________" << endl << "Computation of M = c * A + B * d" << endl << "____________________" << endl;
		cout << endl << "Enter two floating point numbers: ";
		double c, d;
		cin >> c >> d;
		cin.ignore();
		cin.clear();
		Matrix M = A * c + B * c;
		M.print();
		cout << endl << "____________________" << endl << "Computation of P = A * B" << endl << "____________________" << endl;
		cout << endl << "Enter components of Vector x of length " << A.size().second << ": ";
		vector<double> x;
		for (int i = 0; i < A.size().second; ++i)
		{
			cin >> in;
			x.push_back(in);
		}
		vector<double> b = A * x;
		cout << endl << "printing b values: " << endl;
		for (int i = 0; i < b.size(); ++i)
		{
			cout << b[i] << endl;
		}
		cout << endl << "Continue (y/n)? ";
		getline(cin, resp);
		if (resp == "n") break;
	}
	return 0;
}
