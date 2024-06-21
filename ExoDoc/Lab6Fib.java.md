# Lab6
```
// This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
// https://creativecommons.org/licenses/by-nc-nd/4.0/
// Remi Douence

// Please do not distribute solutions but let people learn by doing the exercices.

```
## Pure versus Impure 
this program examplifies that a function can have an internal impure implementation
```

public class Lab6Fib {

```
### Purely Functional Implementation
```
    static int fibR(int n) {
	if (n<=1) {
	    return n;
	} else {
	    return fibR(n-1) + fibR(n-2);
	}
    }
```
### Impure Implementation
```
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
```
### Efficiency Comparison
- fibI n complexity O(n)
- fibR n complexity O(1.6^n)
```
    public static void main(String[] args) {
	for (int i=0; i<46; i++) {
	    System.out.println("fibI(" + i + ") = " + fibI(i));
	    System.out.println("fibR(" + i + ") = " + fibR(i));
      // System.out.println("fibM(" + i + ") = " + fibM(i));

	    System.out.println();
	}
    }
```
## Memoisation
```
    final static int m = 100;
    static int[] memo = new int[m];
    static int fibM(int n) {
  return 0;

    }
}
```
