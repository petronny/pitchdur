package main;

import java.io.FileWriter;

import weka.classifiers.trees.REPTree;
import weka.core.Instance;
import weka.core.Instances;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.Remove;

public class parameters {

	public static void rebuild(Instances input, REPTree[][] cfs) throws Exception {
		for (int i = 0; i < input.numInstances(); i++) {
//			double result = input.instance(i).classValue();
//			double result_test = cfs[0][1].classifyInstance(input.instance(i));
			// test.instance(i).setValue(inputData.attribute("r1"),
			// r1_new[count]);
			// test.instance(i).setValue(inputData.attribute("r2"),r2_new[count]);
		}
	}

	public static REPTree regression(Instances input, String regressionType,
			String filter) throws Exception {
		Instances inputData = new Instances(input);

		// Filter the data
		if (regressionType.equals("linear")) {
			for (int i = inputData.numInstances() - 1; i >= 0; i--) {
				// it's important to iterate from last to first, because when we
				// remove an instance, the rest shifts by one position.
				Instance inst = inputData.instance(i);
				if (inst.stringValue(inputData.attribute("r1")).charAt(0) == '1') {
					inputData.delete(i);
				}
			}
		}
		if (regressionType.equals("quadratic")) {
			for (int i = inputData.numInstances() - 1; i >= 0; i--) {
				Instance inst = inputData.instance(i);
				if (inst.stringValue(inputData.attribute("r1")).charAt(0) == '0') {
					inputData.delete(i);
				}
			}
		}

		for (int i = inputData.numInstances() - 1; i >= 0; i--) {
			// it's important to iterate from last to first, because when we
			// remove an instance, the rest shifts by one position.
			Instance inst = inputData.instance(i);
			if (!tools.haschar(filter,
					inst.stringValue(inputData.attribute("tone0")).charAt(0))) {
				inputData.delete(i);
			}
		}

		double[][] parameters;
		parameters = new double[inputData.numInstances()][2 * Main.numOfTargetAttr + 1];
		double[] totaldiff = new double[Main.numOfTargetAttr];
		REPTree cfs = null;

		for (int selectedAttr = 0; selectedAttr < Main.numOfTargetAttr; selectedAttr++) {

			if (regressionType.equals("linear")) {
				if (selectedAttr == 0)
					selectedAttr++;
				if (selectedAttr == Main.numOfTargetAttr - 1)
					continue;
			}

			// Remove not needed attribute
			Remove remove = new Remove();
			int cIdx = inputData.numAttributes() - 1;
			int[] removeList = new int[Main.numOfTargetAttr - 1];
			for (int j = 0; j < Main.numOfTargetAttr - 1; j++)
				removeList[j] = cIdx - Main.numOfTargetAttr + 1
						+ (selectedAttr + j + 1) % Main.numOfTargetAttr;
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
				cfs = new REPTree();
				// IBk cfs=new IBk(2);

				// Train & Test
				cfs.buildClassifier(train);
				for (int i = 0; i < test.numInstances(); i++) {
					double result = test.instance(i).classValue();
					// test.instance(i).setValue(inputData.attribute("r1"),
					// r1_new[count]);
					// test.instance(i).setValue(inputData.attribute("r2"),r2_new[count]);
					double result_test = cfs.classifyInstance(test.instance(i));
					parameters[count][selectedAttr] = result;
					parameters[count][selectedAttr + Main.numOfTargetAttr] = result_test;
					parameters[count][2 * Main.numOfTargetAttr] = test
							.instance(i).value(inputData.attribute("time"));
					count++;
				}
			}
		}
		for (int i = 0; i < inputData.numInstances(); i++) {
			// scale(parameters[i]);
			// fixAxis(parameters[i]);
			for (int selectedAttr = 0; selectedAttr < Main.numOfTargetAttr; selectedAttr++) {
				double diff = Math.abs(parameters[i][selectedAttr
						+ Main.numOfTargetAttr]
						- parameters[i][selectedAttr]);
				totaldiff[selectedAttr] += diff;
			}
		}

		System.out.printf("parameters-%s-%s:", regressionType, filter);
		for (int i = 0; i < Main.numOfTargetAttr; i++)
			System.out.printf("%f ", totaldiff[i] / inputData.numInstances());
		System.out.printf("\n");

		// Output
		FileWriter output = new FileWriter(String.format("parameters-%s-%s.txt", regressionType, filter));
		for (int i = 0; i < inputData.numInstances(); i++) {
			for (int j = 0; j < Main.numOfTargetAttr * 2 + 1; j++)
				output.write(String.format("%f ", parameters[i][j]));
			output.write("\n");
			output.flush();
		}
		output.close();
		return cfs;
	}
}