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
		
		double r_only[][][];
		r_only=new double[5][][];
		r_only[0]=r1.regression(input,"only",'1');
		r_only[1]=r1.regression(input,"only",'2');
		r_only[2]=r1.regression(input,"only",'3');
		r_only[3]=r1.regression(input,"only",'4');
		r_only[4]=r1.regression(input,"only",'5');
		
		inputFile = new File("data-noglobal1-window0.arff");
		arffLoader = new ArffLoader();
		arffLoader.setFile(inputFile);
		input = arffLoader.getDataSet();
		for(int i=0;i<5;i++){
			parameters.regression(input,"linear","only",(char)('1'+i), r_only[i][0]);
			parameters.regression(input,"quadratic","only",(char)('1'+i), r_only[i][0]);
		}
	}
}