#include <iostream>
#include "symbolicc++.h"

using namespace std;

pair<list<Symbolic>,list<Symbolic> >
make_test(const list<Symbolic> &pe, const list<Symbolic> &v)
{ return make_pair(pe, v); }

pair<list<Symbolic>,list<Symbolic> >
make_test(const list<Symbolic> &pe, const Symbolic &v)
{ list<Symbolic> vs; vs.push_back(v); return make_pair(pe, vs); }

int main(void)
{
 Symbolic a("a"), b("b"), c("c"), x("x"), y("y"), z("z"), n("n");
 Symbolic pattern, expression;
 list<Equations> eq;
 list<Equations>::iterator i;
 list<pair<list<Symbolic>,list<Symbolic> > > tests;
 list<pair<list<Symbolic>,list<Symbolic> > >::iterator j;
 int k;

 tests.push_back(make_test(
  (x + y,   a + b +3*a*b), (x, y) ));
 tests.push_back(make_test(
  (3*x + y, a + b +3*a*b), (x, y) ));
 tests.push_back(make_test(
  (sin(x), sin(a)), x ));
 tests.push_back(make_test(
  (sin(x), sin(a+b)), x ));
 tests.push_back(make_test(
  (sin(x)^2, sin(a)^2), x ));
 tests.push_back(make_test(
  (sin(x)^2, sin(a+b)^2), x ));
 tests.push_back(make_test(
  ((sin(x)^2)+(cos(x)^2), (sin(a)^2)+(cos(a)^2)), x ));
 tests.push_back(make_test(
  (sin(x), (sin(a)^2)+(cos(a)^2)+(sin(b)^2)), x ));
 tests.push_back(make_test(
  (sin(x)^2, (sin(a)^2)+(cos(a)^2)+(sin(b)^2)), x ));
 tests.push_back(make_test(
  ((sin(x)^2)+(cos(x)^2), (sin(a)^2)+(cos(a)^2)+(sin(b)^2)), x ));
 tests.push_back(make_test(
  (z*exp(y*x), a*exp(a*b)), (x, y, z) ));
 tests.push_back(make_test(
  (x+y, exp(a+b)), (x, y) ));
 tests.push_back(make_test(
  (x*y, 3*(~a)*c*(~b)*n), (x, y) ));
 tests.push_back(make_test(
  (x[z]*y, a*b), (x[z], y) ));
 tests.push_back(make_test(
  (x[n]*y, a*b), (x[n], y) ));
 tests.push_back(make_test(
  (~x*y[~x], ~a/~b), (~x, y[~x]) ));
 tests.push_back(make_test(
  (~x*y[~x], ~a*~a/~b), (~x, y[~x]) ));

 for(k=1,j=tests.begin(); j!=tests.end(); j++,k++)
 {
  cout << "======================" << endl
       << "*** Test " << k << endl
       << "======================" << endl
       << "Pattern: " << j->first.front()
       << ",  Expression: "<< j->first.back() << endl;
  eq = j->first.front().match(j->first.back(), j->second);
  cout << "Matches: " << ((eq.size() == 0)?"none.":"") << endl;
  for(i=eq.begin(); i!=eq.end(); i++) cout << *i << endl;
  eq = j->first.back().match_parts(j->first.front(), j->second);
  cout << "Matches in parts: " << ((eq.size() == 0)?"none.":"") << endl;
  for(i=eq.begin(); i!=eq.end(); i++) cout << *i << endl;
 }

 cout << endl << endl;

 cout << "======================" << endl
      << "*** Example 1 " << endl
      << "======================" << endl << endl;

 Symbolic r = ((2*(sin(a)+cos(a))+cos(b))^2)+(sin(b)^2);
 Equations rules = ((x, (sin(x)^2) + (cos(x)^2) == 1),
                    (x, y, y*((sin(x)^2) + (cos(x)^2)) == y),
                    (x, cos(x)*sin(x) == sin(2*x)/2),
                    (x, y, y*((cos(x)^2)-(sin(x)^2)) == y*cos(2*x)));

 cout << "r = " << r << endl;
 cout << "  => " << r[ x, y, y*((sin(x)^2) + (cos(x)^2)) == y ] << endl;
 cout << "  => " << r[ rules ] << endl;

 cout << endl << endl;

 cout << "======================" << endl
      << "*** Example 2 " << endl
      << "======================" << endl << endl;

 Symbolic B("B"), Bd("Bd"), N("N");
 B = ~B; Bd = ~Bd; N = ~N;
 rules = ( B*Bd == Bd*B + 1,
           (n, B*N[n] == sqrt(n)*N[n-1]),
           (n, Bd*N[n] == sqrt(n+1)*N[n+1]) );
 cout << (((B*Bd)^2)*N[3]) << endl << " => ";
 cout << (((B*Bd)^2)*N[3]).subst_all(rules) << endl;
 cout << (((B*Bd)^2)*N[n]) << endl << " => ";
 cout << (((B*Bd)^2)*N[n]).subst_all(rules) << endl;

 cout << endl;
 cout << (((Bd*B)^2)*N[3]) << endl << " => ";
 cout << (((Bd*B)^2)*N[3]).subst_all(rules) << endl;
// cout << (((Bd*B)^2)*N[3]) << endl << " => ";
// cout << (((Bd*B)^2)*N[3]).subst_all(B*Bd == Bd*B + 1) << endl;

 cout << endl << endl;

 cout << "======================" << endl
      << "*** Example 3 " << endl
      << "======================" << endl << endl;

 cout << (B*sin(Bd)) << endl << " => ";
 cout << (B*sin(Bd))[x[Bd], B*x[Bd] == x[Bd]*B - df(x[Bd], Bd)] << endl;
 //cout << (x[Bd], B*x[Bd] == x[Bd]*B - df(x[Bd], Bd)).first << endl;
 //cout << (x[Bd], B*x[Bd] == x[Bd]*B - df(x[Bd], Bd)).second << endl;

 cout << endl << endl;

 return 0;
}
