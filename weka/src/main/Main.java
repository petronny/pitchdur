package main;

import java.io.File;
import java.util.Random;

import weka.classifiers.lazy.IBk;
import weka.core.Instances;
import weka.filters.Filter;
import weka.core.converters.ArffLoader;
import weka.filters.unsupervised.attribute.Remove;

public class Main {

	public static void main(String[] args) throws Exception {

		// Configure the input file
		File inputFile = new File("/home/petron/pitchdur/match/data.arff");
		ArffLoader atf = new ArffLoader();
		atf.setFile(inputFile);
		Instances inst = atf.getDataSet();

		int cIdx = inst.numAttributes() - 1;
		int[] removeList = new int[] { cIdx - 1, cIdx - 2 };
		Remove remove = new Remove();
		remove.setAttributeIndicesArray(removeList);
		remove.setInputFormat(inst);
		Instances input = Filter.useFilter(inst, remove);

		cIdx = input.numAttributes() - 1;
		input.setClassIndex(cIdx);

		// Use Cross Validation
		int seed = 161026;// Just a time
		int folds = 2;
		Random rand = new Random(seed);
		Instances randData = new Instances(input);
		randData.randomize(rand);
		randData.stratify(folds);

		for (int n = 0; n < folds; n++) {
			Instances train = randData.trainCV(folds, n);
			Instances test = randData.testCV(folds, n);

			// Configure the classifier
			IBk cfs = new IBk();
			cfs.setKNN(2);
			String[] options = new String[] {};
			cfs.setOptions(options);

			// Train & Test
			cfs.buildClassifier(train);
			for (int i=0;i<test.numInstances();i++){
				double result_test=cfs.classifyInstance(test.instance(i));
				System.out.println(result_test);
			}
		}
	}
}