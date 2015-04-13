package main;

import java.io.File;
import java.io.FileWriter;
import java.util.Random;

import weka.classifiers.trees.REPTree;
import weka.core.Instances;
import weka.filters.Filter;
import weka.core.converters.ArffLoader;
import weka.filters.unsupervised.attribute.Remove;

public class Main {

	public static void main(String[] args) throws Exception {

		// Configure the input file
		File inputFile = new File("data-noglobal1-round0-window2.arff");
		ArffLoader arffLoader = new ArffLoader();
		arffLoader.setFile(inputFile);
		Instances input = arffLoader.getDataSet();
		int numOfTargetAttr = 6;

		// Randomize the data
		int seed = 161026;// Just a string of time
		Random rand = new Random(seed);
		Instances randData = new Instances(input);
		randData.randomize(rand);
		double[][] parameters;
		String[] tones = new String[randData.numInstances()];
		parameters = new double[randData.numInstances()][2 * numOfTargetAttr + 1];
		double[] totaldiff = new double[numOfTargetAttr];

		for (int selectedAttr = 0; selectedAttr < numOfTargetAttr; selectedAttr++) {

			// Remove not needed attribute
			Remove remove = new Remove();
			int cIdx = randData.numAttributes() - 1;
			int[] removeList = new int[numOfTargetAttr - 1];
			for (int j = 0; j < numOfTargetAttr - 1; j++)
				removeList[j] = cIdx - numOfTargetAttr + 1
						+ (selectedAttr + j + 1) % numOfTargetAttr;
			remove.setAttributeIndicesArray(removeList);
			remove.setInputFormat(randData);
			Instances finalData = Filter.useFilter(randData, remove);
			cIdx = finalData.numAttributes() - 1;
			finalData.setClassIndex(cIdx);

			// Use cross validation
			int folds = 10;
			finalData.stratify(folds);

			int count = 0;
			for (int n = 0; n < folds; n++) {

				System.out.printf("attribute:%d fold:%d\n", selectedAttr, n);

				Instances train = finalData.trainCV(folds, n);
				Instances test = finalData.testCV(folds, n);

				// Configure the classifier
//				LinearRegression cfs = new LinearRegression();
				REPTree cfs = new REPTree();
//				IBk cfs=new IBk(2);

				// Train & Test
				cfs.buildClassifier(train);
				for (int i = 0; i < test.numInstances(); i++) {
					double result = test.instance(i).classValue();
					double result_test = cfs.classifyInstance(test.instance(i));
					double diff = Math.abs(result_test - result);
					parameters[count][selectedAttr] = result;
					parameters[count][selectedAttr + numOfTargetAttr] = result_test;
					tones[count] = test.instance(i).stringValue(
							randData.attribute("initial0"))
							+ test.instance(i).stringValue(
									randData.attribute("vowel0"))
							+ test.instance(i).stringValue(
									randData.attribute("tone0"));
					parameters[count][2 * numOfTargetAttr] = test.instance(i)
							.value(randData.attribute("time"));
					count++;
					if (!Double.isNaN(diff))
						totaldiff[selectedAttr] += diff;
					else
						System.out.printf("NaN error: %d %f %f\n", i,result,result_test);
				}
			}
		}

		for (int i = 0; i < numOfTargetAttr; i++)
			System.out.printf("%f ", totaldiff[i] / randData.numInstances());

		// Output
		FileWriter output = new FileWriter("parameters.txt");
		for (int i = 0; i < randData.numInstances(); i++) {
			for (int j = 0; j < numOfTargetAttr * 2 + 1; j++)
				output.write(String.format("%f ", parameters[i][j]));
			output.write("\n");
			output.flush();
		}
		output.close();
		output = new FileWriter("tones.txt");
		for (int i = 0; i < randData.numInstances(); i++)
			output.write(String.format("%s\n", tones[i]));
		output.close();
	}
}