```
// This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
// https://creativecommons.org/licenses/by-nc-nd/4.0/
// Remi Douence

// Please do not distribute solutions but let people learn by doing the exercices.

```
# Constructor Nil 
- the code here correspond to the equation for the pattern `[]`
```
public class Lab6MyNil<A> extends Lab6MyList<A> {
	public String toString() {
		return "Lab6MyNil";
	}
	Lab6MyList<A> myAppend(Lab6MyList<A> ys) {
		return ys;
	}
	boolean myNull() {
		return true;
	}
```
`myHead` is not defined for `[]`
```
	A myHead() {
		System.out.println("Lab6MyNil.head");
		System.exit(0);
		return null;
	}
```
`myTail` is not defined for `[]`
```
	Lab6MyList<A> myTail() {
		System.out.println("Lab6MyNil.tail");
		System.exit(0);
		return null;
	}
	Lab6MyList myConcat() {
		return this;
	}
```
`equals` override for `[]`
```
	boolean equals(Lab6MyList<A> ys) {
		return ys.myNull();
	}
}
```
