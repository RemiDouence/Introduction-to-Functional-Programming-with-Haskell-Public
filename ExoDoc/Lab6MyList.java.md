```
// This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
// https://creativecommons.org/licenses/by-nc-nd/4.0/
// Remi Douence

// Please do not distribute solutions but let people learn by doing the exercices.

```
# Haskell lists in Java
- how to translate `data List a = Nil | Cons a (List a)` in Java 
- 1 Haskell type = 1 Java abstract class (interface + some generic functions)
```
public abstract class Lab6MyList<A> {
```
- the methods are `abstract` are implemented in the subclasses (a.k.a. constructors)
- one less argument: the first argument in Haskell becomes the receiver in Java
```
	abstract Lab6MyList<A> myAppend(Lab6MyList<A> ys);
	abstract boolean myNull();
	abstract A myHead();
	abstract Lab6MyList<A> myTail();
	abstract Lab6MyList myConcat();
       // define the method `myConcat` in `Lab6MyNil` and `Lab6MyCons`
        
	static <A> Lab6MyList<A> myConcat2(Lab6MyList<Lab6MyList<A>> xss) 
       { return null; } // define the `static` method `myConcat` here without warning
    
	abstract boolean equals(Lab6MyList<A> ys);
	public static void main(String[] args) {
		Lab6MyList<String> l1 = new Lab6MyCons<String>("a",new Lab6MyCons<String>("b",new Lab6MyNil<String>()));
		Lab6MyList<String> l2 = new Lab6MyCons<String>("c",new Lab6MyCons<String>("d",new Lab6MyNil<String>()));
		System.out.println(l1);
		System.out.println(l2);
		System.out.println(l1.myAppend(l2));
		System.out.println(l1);
		System.out.println(l2);
		Lab6MyList<Lab6MyList<String>> l3 = new Lab6MyCons<Lab6MyList<String>>(l1,new Lab6MyCons<Lab6MyList<String>>(l2, new Lab6MyNil<Lab6MyList<String>>()));
		System.out.println(l3);
		System.out.println(l3.myConcat());
		System.out.println(Lab6MyList.myConcat2(l3));
		System.out.println(l3.myConcat().equals(Lab6MyList.myConcat2(l3)));
	}
}
```
