package main;

import java.io.File;
import java.io.FileWriter;

import weka.classifiers.functions.LibSVM;
import weka.core.Instance;
import weka.core.Instances;
import weka.filters.Filter;
import weka.core.converters.ArffLoader;
import weka.filters.unsupervised.attribute.Remove;

public class r1r2Classification {
	public static int numOfTargetAttr = 8;

	public static void main(String[] args) throws Exception {

		// Configure the input file
		File inputFile = new File("data-noglobal1-round1-window0.arff");
		ArffLoader arffLoader = new ArffLoader();
		arffLoader.setFile(inputFile);
		Instances input = arffLoader.getDataSet();

		// Filter the data
		for (int i = input.numInstances() - 1; i >= 0; i--) {
			// it's important to iterate from last to first, because when we
			// remove an instance, the rest shifts by one position.
			Instance inst = input.instance(i);
			if (inst.stringValue(input.attribute("tone0")).charAt(0) == 'x') {
				input.delete(i);
			}
		}

		// Randomize the data
		Instances randData = new Instances(input);
		// int seed = 161026;// Just a string of time
		// Random rand = new Random(seed);
		// randData.randomize(rand);

		int[][] parameters;
		String[] tones = new String[randData.numInstances()];
		parameters = new int[randData.numInstances()][2 * numOfTargetAttr + 1];

		for (int selectedAttr = 0; selectedAttr < 2; selectedAttr++) {

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
				LibSVM cfs = new LibSVM();

				// Train & Test
				cfs.buildClassifier(train);
				for (int i = 0; i < test.numInstances(); i++) {
					double result = test.instance(i).classValue();
					double result_test = cfs.classifyInstance(test.instance(i));
					parameters[count][selectedAttr] = (int) result;
					parameters[count][selectedAttr + numOfTargetAttr] = (int) result_test;
					tones[count] = test.instance(i).stringValue(
							randData.attribute("initial0"))
							+ test.instance(i).stringValue(
									randData.attribute("vowel0"))
							+ test.instance(i).stringValue(
									randData.attribute("tone0"));
					count++;
				}
			}
		}
		for (int selectedAttr = 0; selectedAttr < 2; selectedAttr++) {
			int[][] totaldiff = new int[3][3];
			for (int i = 0; i < randData.numInstances(); i++)
				totaldiff[parameters[i][selectedAttr]][parameters[i][selectedAttr
						+ numOfTargetAttr]] += 1;
			for (int line = 0; line < 3; line++) {
				for (int row = 0; row < 3; row++)
					System.out.printf("%d ", totaldiff[line][row]);
				System.out.printf("\n");
			}
			System.out.printf("%f\n",(double)(totaldiff[0][0]+totaldiff[1][1]+totaldiff[2][2])/randData.numInstances());
		}

		// Output
		FileWriter output = new FileWriter("r1r2.txt");
		for (int i = 0; i < randData.numInstances(); i++) {
			output.write(String.format("%s\t", tones[i]));
			output.write(String.format("%d %d\t", parameters[i][0] - 1,
					parameters[i][1] - 1));
			output.write(String.format("%d %d\n",
					parameters[i][numOfTargetAttr] - 1,
					parameters[i][numOfTargetAttr + 1] - 1));
			output.flush();
		}
		output.close();
	}
}