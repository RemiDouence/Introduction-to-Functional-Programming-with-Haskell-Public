
// This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
// https://creativecommons.org/licenses/by-nc-nd/4.0/
// Remi Douence

// Please do not distribute solutions but let people learn by doing the exercices.


public class Lab6MyCons<A> extends Lab6MyList<A> {
	A head;
	Lab6MyList<A> tail;
	public Lab6MyCons(A head, Lab6MyList<A> tail) {
		this.head = head;
		this.tail = tail;
	}
	public String toString() {
		return "(Lab6MyCons " + head + " " + tail + ")";
	}
	Lab6MyList<A> myAppend(Lab6MyList<A> ys) {
		return new Lab6MyCons<A>(head,tail.myAppend(ys));
	}
	boolean myNull() {
		return false;
	}
	A myHead() {
		return head;
	}
	Lab6MyList<A> myTail() {
		return tail;
	}
	Lab6MyList myConcat() {
		return ((Lab6MyList)myHead()).myAppend(myTail().myConcat());
	}
	boolean equals(Lab6MyList<A> ys) {
		return !ys.myNull() && myHead().equals(ys.myHead()) && myTail().equals(ys.myTail());
	}
}
