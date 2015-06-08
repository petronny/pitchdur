package main;

import java.io.File;
import weka.classifiers.trees.REPTree;
import weka.core.Instances;
import weka.core.converters.ArffLoader;

public class Main {
	public static int numOfTargetAttr = 6;

	public static void main(String[] args) throws Exception {

		// Configure the input file
		File inputFile = new File("data-noglobal1-window1.arff");
		ArffLoader arffLoader = new ArffLoader();
		arffLoader.setFile(inputFile);
		Instances input = arffLoader.getDataSet();

		double r[][][] = new double[5][][];
		for (int i = 0; i < 5; i++)
			r[i] = r1.regression(input, String.format("%d", i + 1));

		inputFile = new File("data-noglobal1-window0.arff");
		arffLoader = new ArffLoader();
		arffLoader.setFile(inputFile);
		input = arffLoader.getDataSet();

		REPTree[][] cfs = new REPTree[5][2];

		for (int i = 0; i < 5; i++)
			cfs[i][0] = parameters.regression(input, "linear",
					String.format("%d", 1 + i));
		for (int i = 0; i < 5; i++)
			cfs[i][1] = parameters.regression(input, "quadratic",
					String.format("%d", 1 + i));
		for (int i = 0; i < 5; i++) {
			parameters.rebuild(input,cfs,r);
		}
	}
}