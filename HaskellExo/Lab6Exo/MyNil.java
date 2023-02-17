// This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
// https://creativecommons.org/licenses/by-nc-nd/4.0/
// Remi Douence

// Please do not distribute solutions but let people learn by doing the exercices.

public class MyNil<A> extends MyList<A> {
	public String toString() {
		return "MyNil";
	}
	boolean myNull() {
		return true;
	}
	A myHead() {
		System.out.println("MyNil.head");
		System.exit(0);
		return null;
	}
	MyList<A> myTail() {
		System.out.println("MyNil.tail");
		System.exit(0);
		return null;
	}
	MyList<A> myAppend(MyList<A> ys) {
		return ys;
	}
	boolean equals(MyList<A> ys) {
		return ys.myNull();
	}
}
