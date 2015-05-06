package main;

import java.io.FileWriter;

import weka.classifiers.trees.REPTree;
import weka.core.Instance;
import weka.core.Instances;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.Remove;

public class r2 {

	public static double[][] regression(Instances input, String subfix)
			throws Exception {
		Instances inputData = new Instances(input);

		if (subfix.equals("only1")) {
			for (int i = input.numInstances() - 1; i >= 0; i--) {
				// it's important to iterate from last to first, because when we
				// remove an instance, the rest shifts by one position.
				Instance inst = inputData.instance(i);
				if (inst.stringValue(inputData.attribute("tone0")).charAt(0) != '1') {
					inputData.delete(i);
				}
			}
		}

		if (subfix.equals("expect1")) {
			for (int i = input.numInstances() - 1; i >= 0; i--) {
				Instance inst = inputData.instance(i);
				if (inst.stringValue(inputData.attribute("tone0")).charAt(0) == '1') {
					inputData.delete(i);
				}
			}
		}

		double[][] parameters;
		parameters = new double[2][inputData.numInstances()];

		// Remove not needed attribute
		Remove remove = new Remove();
		int cIdx = inputData.numAttributes() - 1;
		int[] removeList = new int[Main.numOfTargetAttr+1];
		for (int j = 0; j < Main.numOfTargetAttr; j++)
			removeList[j] = cIdx - j;
		removeList[Main.numOfTargetAttr] = cIdx - Main.numOfTargetAttr-1;
		remove.setAttributeIndicesArray(removeList);
		remove.setInputFormat(inputData);

		Instances finalData = Filter.useFilter(inputData, remove);
		cIdx = finalData.numAttributes() - 1;
		finalData.setClassIndex(cIdx);

		// Use cross validation
		int folds = 10;
		finalData.stratify(folds);

		int count = 0;
		for (int n = 0; n < folds; n++) {

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
				parameters[0][count] = result;
				parameters[1][count] = result_test;
				count++;
			}
		}

		double totaldiff1 = 0;
		for (int i = 0; i < inputData.numInstances(); i++) {
			double diff = Math.abs(parameters[0][i] - parameters[1][i]);
			totaldiff1 += diff;
		}
		System.out.printf("r2-%s\t: %f\n", subfix,totaldiff1 / inputData.numInstances());

		// Output
		FileWriter output = new FileWriter(String.format("r2-%s.txt", subfix));
		for (int i = 0; i < inputData.numInstances(); i++) {
			// output.write(String.format("%s ", tones[i]));
			output.write(String.format("%f ", parameters[0][i]));
			output.write(String.format("%f\n", parameters[1][i]));
			output.flush();
		}
		output.close();
		return parameters;
	}
}