// This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
// https://creativecommons.org/licenses/by-nc-nd/4.0/
// Remi Douence

// Please do not distribute solutions but let people learn by doing the exercices.

public class Fib {

	static int fibR(int n) {
		if (n<=1) {
			return n;
		} else {
			return fibR(n-1) + fibR(n-2);
		}
	}
	static int fibI(int n) {
		 int x=0;
		 int y=1;
		 for(int i=1;i<=n;++i) {
			 int tmp = y;
			 y = x+y;
			 x = tmp;   
		 }
		 return x;
	}
	public static void main(String[] args) {
		for (int i=0; i<10; i++) {
			System.out.println(fibR(i));
			System.out.println(fibI(i));
		}
		//System.exit(0);
		System.out.println("FibR");
		System.out.println(fibR(43));
		System.out.println(fibR(44));
		System.out.println(fibR(45));
		System.out.println(fibR(46));
		
		System.out.println("FibI");
		System.out.println(fibI(43));
		System.out.println(fibI(44));
		System.out.println(fibI(45));
		System.out.println(fibI(46));
		// fib n complexity O(1.6^n)
	}
}
