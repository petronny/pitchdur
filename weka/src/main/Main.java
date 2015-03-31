package main;

import java.io.File;
import java.io.FileWriter;
import java.util.Random;

import weka.classifiers.lazy.IBk;
import weka.core.Instances;
import weka.filters.Filter;
import weka.core.converters.ArffLoader;
import weka.filters.unsupervised.attribute.Remove;

public class Main {

	public static void main(String[] args) throws Exception {

		// Configure the input file
		File inputFile = new File("data.arff");
		ArffLoader arffLoader = new ArffLoader();
		arffLoader.setFile(inputFile);
		Instances input = arffLoader.getDataSet();

		// Randomize the data
		int seed = 161026;// Just a string of time
		Random rand = new Random(seed);
		Instances randData = new Instances(input);
		randData.randomize(rand);
		double[][] parameters;
		parameters = new double[randData.numInstances()][6];

		for (int selectedAttr = 0; selectedAttr < 3; selectedAttr++) {

			// Remove not needed attribute
			Remove remove = new Remove();
			int cIdx = randData.numAttributes() - 1;
			int[] removeList = new int[] { cIdx - 2 + (selectedAttr + 1) % 3,
					cIdx - 2 + (selectedAttr + 2) % 3 };
			remove.setAttributeIndicesArray(removeList);
			remove.setInputFormat(randData);
			Instances finalData = Filter.useFilter(randData, remove);
			cIdx = finalData.numAttributes() - 1;
			finalData.setClassIndex(cIdx);

			// Use cross validation
			int folds = 2;
			finalData.stratify(folds);

			int count = 0;
			for (int n = 0; n < folds; n++) {

				Instances train = finalData.trainCV(folds, n);
				Instances test = finalData.testCV(folds, n);

				// Configure the classifier
				IBk cfs = new IBk();
				cfs.setKNN(20);
				String[] options = new String[] {};
				cfs.setOptions(options);

				// Train & Test
				cfs.buildClassifier(train);
				double totaldiff = 0;
				for (int i = 0; i < test.numInstances(); i++) {
					double result = test.instance(i).classValue();
					double result_test = cfs.classifyInstance(test.instance(i));
					double diff = Math.abs(result_test - result);
					parameters[count][selectedAttr] = result;
					parameters[count][selectedAttr + 3] = result_test;
					count++;
					totaldiff += diff;
				}
				System.out.printf("%f\n", totaldiff / test.numInstances());
			}
		}

		// Output
		FileWriter output = new FileWriter("parameters.txt");
		for (int i = 0; i < randData.numInstances(); i++) {
			for (int j = 0; j < 6; j++)
				output.write(String.format("%f ", parameters[i][j]));
			output.write("\n");
			output.flush();
		}
		output.close();
	}
}