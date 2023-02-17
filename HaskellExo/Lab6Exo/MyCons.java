// This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
// https://creativecommons.org/licenses/by-nc-nd/4.0/
// Remi Douence

// Please do not distribute solutions but let people learn by doing the exercices.

public class MyCons<A> extends MyList<A> {
	A head;
	MyList<A> tail;
	public MyCons(A head, MyList<A> tail) {
		this.head = head;
		this.tail = tail;
	}
	public String toString() {
		return "(MyCons " + head + " " + tail + ")";
	}
	boolean myNull() {
		return false;
	}
	A myHead() {
		return head;
	}
	MyList<A> myTail() {
		return tail;
	}
	MyList<A> myAppend(MyList<A> ys) {
		return new MyCons<A>(head,tail.myAppend(ys));
	}
	boolean equals(MyList<A> ys) {
		return !ys.myNull() && myHead().equals(ys.myHead()) && myTail().equals(ys.myTail());
	}
}
