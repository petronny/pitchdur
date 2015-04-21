package main;

import java.io.File;
import java.io.FileWriter;

import weka.classifiers.trees.REPTree;
import weka.core.Instance;
import weka.core.Instances;
import weka.filters.Filter;
import weka.core.converters.ArffLoader;
import weka.filters.unsupervised.attribute.Remove;

public class Main {
	public static int numOfTargetAttr = 6;

	public static void scale(double[] para) {
		double a = para[numOfTargetAttr];
		double b = para[numOfTargetAttr + 1];
		double c = para[numOfTargetAttr + 2];
		double time = para[numOfTargetAttr * 2];
		double ax = -b / 2 / a;
		double ay = -(b * b - 4 * a * c) / 4 / a / a;
		double min1 = Math.min(c, a * time * time + b * time + c);
		double max1 = Math.max(c, a * time * time + b * time + c);
		if (ax > 0 && ax < time) {
			min1 = Math.min(min1, ay);
			max1 = Math.max(max1, ay);
		}
		double min2 = para[numOfTargetAttr + 3];
		double max2 = para[numOfTargetAttr + 4];
		if (min1 < max1) {
			para[numOfTargetAttr] = a * (max2 - min2) / (max1 - min1);
			para[numOfTargetAttr + 1] = b * (max2 - min2) / (max1 - min1);
			para[numOfTargetAttr + 2] = (c - min1) * (max2 - min2)
					/ (max1 - min1) + min2;
		}
	}

	public static void main(String[] args) throws Exception {

		// Configure the input file
		File inputFile = new File("data-noglobal1-round0-window0.arff");
		ArffLoader arffLoader = new ArffLoader();
		arffLoader.setFile(inputFile);
		Instances input = arffLoader.getDataSet();

		// Filter the data
		for (int i = input.numInstances() - 1; i >= 0; i--) {
			// it's important to iterate from last to first, because when we
			// remove an instance, the rest shifts by one position.
			Instance inst = input.instance(i);
			if (inst.stringValue(input.attribute("tone0")).charAt(0) != '1') {
				input.delete(i);
			}
		}

		// Randomize the data
		Instances randData = new Instances(input);
		// int seed = 161026;// Just a string of time
		// Random rand = new Random(seed);
		// randData.randomize(rand);

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
				// LinearRegression cfs = new LinearRegression();
				REPTree cfs = new REPTree();
				// IBk cfs=new IBk(2);

				// Train & Test
				cfs.buildClassifier(train);
				for (int i = 0; i < test.numInstances(); i++) {
					double result = test.instance(i).classValue();
					double result_test = cfs.classifyInstance(test.instance(i));
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
				}
			}
		}
		for (int i = 0; i < randData.numInstances(); i++) {
			// scale(parameters[i]);
			for (int selectedAttr = 0; selectedAttr < numOfTargetAttr; selectedAttr++) {
				double diff = Math.abs(parameters[i][selectedAttr
						+ numOfTargetAttr]
						- parameters[i][selectedAttr]);
				totaldiff[selectedAttr] += diff;
			}
		}

		for (int i = 0; i < numOfTargetAttr; i++)
			System.out.printf("%f ", totaldiff[i] / randData.numInstances());

		// Output
		FileWriter output = new FileWriter("parameters-only1.txt");
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