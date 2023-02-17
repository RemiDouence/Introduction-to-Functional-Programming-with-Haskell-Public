// This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
// https://creativecommons.org/licenses/by-nc-nd/4.0/
// Remi Douence

// Please do not distribute solutions but let people learn by doing the exercices.

import java.util.ArrayList;
import java.util.List;

public class QuickSort {
	// time in milliseconds
	private static long start;
	public static void start() {
		start = System.currentTimeMillis();
	}
	public static long stop() {
		return (System.currentTimeMillis()-start);
	}
	// on/off print argument and result
	public static boolean print = true;
	// print list of Integer
	public static void print(String prefix,List<Integer> xs) {
		if (print) {
			System.out.println(prefix + xs);
		}
	}
	// print array of int
	public static void print(String prefix,int[] xs) {
		if (print) {
			System.out.print(prefix + "[" + xs[0]);
			for (int i=1; i<xs.length; i++) {
				System.out.print(", " + xs[i]);				
			}
			System.out.println("]");
		}
	}
	public static void main(String[] args) {
		System.out.println("main");
		List<Integer> input = new ArrayList<Integer>();
		int nbElements = 9;
		print = nbElements<20;
		for (int i=nbElements; i>0; i--) {
			input.add(i);
		}
		List<Integer> output;
		// 1) buggy fun, fix it
		System.out.println("VERSION 1");
		start();
		output = QuickSort.sort1(input);
		System.out.println("time=" + stop()); 
		print("input =",input);
		print("output=",output);
		
		// 2) fun (remove a local copy)
		System.out.println("VERSION 2");
		start();
		output = QuickSort.sort2(input);
		System.out.println("time=" + stop()); 
		//print("input =",input);
		print("output=",output);
		
		// 3) fun (remove both local copy)
		System.out.println("VERSION 3");
		List<Integer> inputBis = new ArrayList<Integer>(input);
		start();
		output = QuickSort.sort3(inputBis); // beware mutate the input
		System.out.println("time=" + stop()); 
		//print("input =",inputBis);
		print("output=",output);

		// 4) in situ
		System.out.println("VERSION 4");
		int[] inputA = new int[input.size()];
		int index = 0;
		for (int i: input) {
			inputA[index++] = i;
		}
		//print("input =",inputA);
		start();
		QuickSort.sort4(inputA,0,inputA.length-1);
		System.out.println("time=" + stop()); 
		print("output=",inputA);
		
		// 5) in situ and no recursion
		System.out.println("VERSION 5");
		index = 0;
		for (int i:input) {
			inputA[index++] = i;
		}
		//print("input =",inputA);
		start();
		QuickSort.sort5(inputA);
		System.out.println("time=" + stop()); 
		print("output=",inputA);
	}
	// functional version 1: identify and correct the bug
	public static List<Integer> sort1(List<Integer> xs) {
		if (xs.size()<=1) {
			return xs;
		} else {
			// split
			int pivot = xs.get(0);
			List<Integer> lower = new ArrayList<Integer>();
			List<Integer> upper = new ArrayList<Integer>();
			for (Integer i:xs) {
				if (i<=pivot) {
					lower.add(i);
				} else {
					upper.add(i);
				}
			}
			lower.remove(0);
			// subsort
			lower = QuickSort.sort1(lower);
			upper = QuickSort.sort1(upper);
			List<Integer> result = new ArrayList<Integer>();
			result.addAll(lower);
			result.addAll(upper);
			return result;
		}
	}
	// functional version 2: do not create the list "result" 
	public static List<Integer> sort2(List<Integer> xs) {
		if (xs.size()<=1) {
			return xs;
		} else {
			// split
			int pivot = xs.get(0);
			List<Integer> lower = new ArrayList<Integer>();
			List<Integer> upper = new ArrayList<Integer>();
			for (Integer i:xs) {
				if (i<=pivot) {
					lower.add(i);
				} else {
					upper.add(i);
				}
			}
			lower.remove(0);
			// subsort
			// ...
			return null; // dummy return to be deleted
		}
	}
	// functional version 3: do not create the list "lower"
	public static List<Integer> sort3(List<Integer> xs) {
		if (xs.size()<=1) {
			return xs;
		} else {
			// split
			// ...
			// subsort
			// ...
			return xs;
		}
	}
	// imperative version 1: do not create lists but sort the array in situ
	public static void sort4(int[] xs, int begin, int end) {
		if (begin<end) {
			int pivot = split(xs,begin,end);
			// subsort
			sort4(xs,begin,pivot-1);
			sort4(xs,pivot+1,end);
		}
	}	
	// split arguments = array, array index begin, array index end
	// split return = index of the pivot
	static int split(int[] xs, int begin, int end) {
		int pivot = begin;
		for (int i = begin+1; i<=end; i++) {
			if (xs[i]<=xs[pivot]) {
				if (i==pivot+1) {
					// ...
				} else {
					// ...
				}
			}
		}
		return pivot;
	}
	// imperative version 2: replace recursive calls by an explicit stack
	public static void sort5(int[] xs) {
		int[] stackOfBegin = new int[xs.length]; // max depth rec
		int[] stackOfEnd   = new int[xs.length]; // max depth rec
		int stack = 0;
		// aka init push
		// ...
		while (stack>0) {
			// ...
		}	
	}
}
