/*
* C++ Program to Implement Traveling Salesman Problem using Nearest neighbour Algorithm
 */
#include <stdio.h>
//#include <conio.h>
#include <iostream>
using namespace std;

int c = 0,cost = 10000;
// int graph[4][4] = { {0, 10, 15, 20},
//                     {10, 0, 35, 25},
//                     {15, 35, 0, 30},
//                     {20, 25, 30, 0}
//                   };

int graph[5][5] ={ { 0, 51,217,169,454},
                { 51, 0,182,163,449},
                {217,182, 0, 151,373},
                {169,163,151, 0,289},
                {454,449,373,289,0} 
                         };

void swap (int *x, int *y)
{
    int temp;
    temp = *x;
    *x = *y;
    *y = temp;
}
void copy_array(int *a, int n)
{
    int i, sum = 0;
    for(i = 0; i <= n; i++)
    {
        sum += graph[a[i % 5]][a[(i + 1) % 5]];
    }
    if (cost > sum)
    {
        cost = sum;
    }
}  
void permute(int *a, int i, int n) 
{
   int j, k; 
     int *y;
   if (i == n)
   {
        copy_array(a, n);
   }
   else
   {
        for (j = i; j <= n; j++)
        {
            cout<<*a<<endl;
            swap((a + i), (a + j));
            permute(a, i + 1, n);
            swap((a + i), (a + j));
        }
    }
    cout<<"////////////////////"<<endl;
    for(int i = 0; i<5; i++){
        y = &a[i];
        cout<<"Value is: "<<*y<<endl;
    }
} 
int main()
{
   int i, j;
  

   int a[] = {0, 1, 2,3, 4};  
   permute(a, 1, 4);
   

   cout<<"minimum cost:"<<cost<<endl;
   //getch();
}