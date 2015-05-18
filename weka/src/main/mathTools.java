package main;

public class mathTools {

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
}