package main;

import java.io.FileWriter;

import weka.classifiers.trees.REPTree;
import weka.core.Instance;
import weka.core.Instances;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.Remove;

public class parameters {

	public static void fixAxis(double[] para) {
		double a = para[Main.numOfTargetAttr];
		if (a > 0) {
			double ax = para[Main.numOfTargetAttr + 5];
			double time = para[Main.numOfTargetAttr * 2];
			ax = time * ax;
			para[Main.numOfTargetAttr + 1] = -2 * a * ax;
		}
	}

	public void scale(double[] para) {
		double a = para[Main.numOfTargetAttr];
		double b = para[Main.numOfTargetAttr + 1];
		double c = para[Main.numOfTargetAttr + 2];
		double time = para[Main.numOfTargetAttr * 2];
		double ax = -b / 2 / a;
		double ay = -(b * b - 4 * a * c) / 4 / a / a;
		double min1 = Math.min(c, a * time * time + b * time + c);
		double max1 = Math.max(c, a * time * time + b * time + c);
		if (ax > 0 && ax < time) {
			min1 = Math.min(min1, ay);
			max1 = Math.max(max1, ay);
		}
		double min2 = para[Main.numOfTargetAttr + 3];
		double max2 = para[Main.numOfTargetAttr + 4];
		if (min1 < max1) {
			para[Main.numOfTargetAttr] = a * (max2 - min2) / (max1 - min1);
			para[Main.numOfTargetAttr + 1] = b * (max2 - min2) / (max1 - min1);
			para[Main.numOfTargetAttr + 2] = (c - min1) * (max2 - min2)
					/ (max1 - min1) + min2;
		}
	}

	public static void regression(Instances input, String subfix, char subchar,
			double[] r1_new) throws Exception {
		Instances inputData = new Instances(input);

		// Filter the data
		if (subfix.equals("only")) {
			for (int i = input.numInstances() - 1; i >= 0; i--) {
				// it's important to iterate from last to first, because when we
				// remove an instance, the rest shifts by one position.
				Instance inst = inputData.instance(i);
				if (inst.stringValue(inputData.attribute("tone0")).charAt(0) != subchar) {
					inputData.delete(i);
				}
			}
		}

		if (subfix.equals("expect")) {
			for (int i = input.numInstances() - 1; i >= 0; i--) {
				Instance inst = inputData.instance(i);
				if (inst.stringValue(inputData.attribute("tone0")).charAt(0) == subchar) {
					inputData.delete(i);
				}
			}
		}

		double[][] parameters;
		parameters = new double[inputData.numInstances()][2 * Main.numOfTargetAttr + 1];
		double[] totaldiff = new double[Main.numOfTargetAttr];

		for (int selectedAttr = 0; selectedAttr < Main.numOfTargetAttr; selectedAttr++) {

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
				REPTree cfs = new REPTree();
				// IBk cfs=new IBk(2);

				// Train & Test
				cfs.buildClassifier(train);
				for (int i = 0; i < test.numInstances(); i++) {
					double result = test.instance(i).classValue();
					test.instance(i).setValue(inputData.attribute("r1"),
							r1_new[count]);
//					test.instance(i).setValue(inputData.attribute("r2"),r2_new[count]);
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
//			fixAxis(parameters[i]);
			for (int selectedAttr = 0; selectedAttr < Main.numOfTargetAttr; selectedAttr++) {
				double diff = Math.abs(parameters[i][selectedAttr
						+ Main.numOfTargetAttr]
						- parameters[i][selectedAttr]);
				totaldiff[selectedAttr] += diff;
			}
		}

		System.out.printf("parameters-%s%c\t:", subfix,subchar);
		for (int i = 0; i < Main.numOfTargetAttr; i++)
			System.out.printf("%f ", totaldiff[i] / inputData.numInstances());
		System.out.printf("\n");

		// Output
		FileWriter output = new FileWriter(String.format("parameters-%s%c.txt",
				subfix,subchar));
		for (int i = 0; i < inputData.numInstances(); i++) {
			for (int j = 0; j < Main.numOfTargetAttr * 2 + 1; j++)
				output.write(String.format("%f ", parameters[i][j]));
			output.write("\n");
			output.flush();
		}
		output.close();
	}
}