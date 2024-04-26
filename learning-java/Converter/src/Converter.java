/*

    @   2garlicbread
    #   Simple command line application for converting things. Currently only converts Fahrenheit to Celcius.
    /   https://github.com/2garlicbread/useless-shit/blob/main/learning-java/Converter/src/Converter.java

 */

public class Converter {
    public static void main(String[] params) {
        if (params.length < 1) return;

        System.out.println("Converting...");

        switch (params[0]) {
            case "-f":
                fahrenheitToCelcius(removeFirstElement(params));
                break;

            case "-h":
                help();
                break;

            default:
                System.out.println(params[0] + " is not a valid command.");
                break;
        }
    }

    public static void fahrenheitToCelcius(String[] numbers) {
        for (String number : numbers) {
            number = number.replaceAll("[^\\d.]", "");

            if (number.isEmpty()) number = "0";

            float f = Float.parseFloat(number);
            f = ((f - 32) * 5) / 9;

            System.out.println(f);
        }
    }

    public static String[] removeFirstElement(String[] arr) {
        if (arr.length <= 1) return new String[0];

        String[] finalArr = new String[arr.length - 1];
        System.arraycopy(arr, 1, finalArr, 0, finalArr.length);

        return finalArr;
    }

    public static void help() {
        System.out.print("""
            -h         |    Help.
            -f float[] |    Fahrenheit to Celcius.
        """);
    }
}
