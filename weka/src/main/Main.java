package main;

import java.io.File;
import java.io.FileWriter;

import weka.classifiers.functions.LibSVM;
import weka.core.Instance;
import weka.core.Instances;
import weka.filters.Filter;
import weka.core.converters.ArffLoader;
import weka.filters.unsupervised.attribute.Remove;

public class Main {
	public static int numOfTargetAttr = 6;

	public static void main(String[] args) throws Exception {

		// Configure the input file
		File inputFile = new File("data-noglobal1-window1.arff");
		ArffLoader arffLoader = new ArffLoader();
		arffLoader.setFile(inputFile);
		Instances input = arffLoader.getDataSet();
		
		double [][] r1_only1=r1.regression(input,"only",'1');
		double [][] r1_only2=r1.regression(input,"only",'2');
		double [][] r1_only3=r1.regression(input,"only",'3');
		double [][] r1_only4=r1.regression(input,"only",'4');
		double [][] r1_only5=r1.regression(input,"only",'5');
		
		inputFile = new File("data-noglobal1-window0.arff");
		arffLoader = new ArffLoader();
		arffLoader.setFile(inputFile);
		input = arffLoader.getDataSet();
		parameters.regression(input, "only",'1', r1_only1[1]);
		parameters.regression(input, "only",'2', r1_only2[1]);
		parameters.regression(input, "only",'3', r1_only3[1]);
		parameters.regression(input, "only",'4', r1_only4[1]);
		parameters.regression(input, "only",'5', r1_only5[1]);
	}
}