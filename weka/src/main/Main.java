package main;
import java.io.File;
import java.util.Random;

import weka.classifiers.Classifier;
import weka.core.Instances;
import weka.core.converters.ArffLoader;
import weka.classifiers.evaluation.Evaluation;
import weka.classifiers.functions.MultilayerPerceptron;
import weka.classifiers.lazy.IBk;
public class Main {

	public static void main(String[] args) throws Exception{
		// TODO Auto-generated method stub
		MultilayerPerceptron m_classifier = new  MultilayerPerceptron();
		IBk cfs=new IBk();
		cfs.setKNN(2);
		String[] options = new String[] {"-L","0.3"};
		m_classifier.setOptions(options);
	     File inputFile = new File("/home/petron/pitchdur/match/data.arff");//训练语料文件
	        ArffLoader atf = new ArffLoader(); 
			 atf.setFile(inputFile);
	        Instances instancesTrain = atf.getDataSet(); // 读入训练文件
	        int cIdx=instancesTrain.numAttributes()-1;
	        instancesTrain.setClassIndex(cIdx);
	        
	        Evaluation eval = new Evaluation(instancesTrain);
	        eval.crossValidateModel(m_classifier, instancesTrain, 2, new Random(1));
//	        inputFile = new File("/home/petron/weka/src/weka-3-7-12/data/cpu.with.vendor.arff");//测试语料文件
//	        atf.setFile(inputFile);          
//	        Instances instancesTest = atf.getDataSet(); // 读入测试文件
//	        instancesTest.setClassIndex(0); //设置分类属性所在行号（第一行为0号），instancesTest.numAttributes()可以取得属性总数
//	        double sum = instancesTest.numInstances(),//测试语料实例数
//	        right = 0.0f;
//	        instancesTrain.setClassIndex(0);
//	 
//	        m_classifier.buildClassifier(instancesTrain); //训练            
//	        for(int  i = 0;i<sum;i++)//测试分类结果
//	        {
//	            if(m_classifier.classifyInstance(instancesTest.instance(i))==instancesTest.instance(i).classValue())//如果预测值和答案值相等（测试语料中的分类列提供的须为正确答案，结果才有意义）
//	            {
//	              right++;//正确值加1
//	            }
//	        }
//	        System.out.println("J48 classification precision:"+(right/sum));
	}
}