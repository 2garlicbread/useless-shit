/*

    Simple command line application for converting things.

    @   2garlicbread
    #   26.04.2024
    /   https://github.com/2garlicbread/useless-shit/blob/main/learning-java/Converter/src/Converter.java


    TODO:
        Double check everything works as intended,
        °C to K,
        °F to K,
        K to °C,
        K to °F

 */

public class Converter {
    public static void main(String[] params) {
        if (params.length < 1) return;

        System.out.println("Converting...");

        String[] newParams = removeFirstElement(params);

        switch (params[0]) {
            case "-fc":
                fahrenheitToCelcius(newParams);
                break;

            case "-h":
                help();
                break;

            case "-cf":
                celciusToFahrenheit(newParams);
                break;

            default:
                System.out.println("'" + params[0] + "'" + " is not a valid command.");
                break;
        }
    }

    public static void celciusToFahrenheit(String[] numbers) {
        float[] newNumbers = stringsToFloats(numbers);

        for (float number : newNumbers) {
            System.out.println(number * 9 / 5 + 32);
        }
    }

    public static void fahrenheitToCelcius(String[] numbers) {
        float[] newNumbers = stringsToFloats(numbers);

        for (float number : newNumbers) {
            System.out.println(number * 5 / 9 - 32);
        }
    }

    public static float[] stringsToFloats(String[] strings) {
        float[] floats = new float[strings.length];

        for (int i = 0; i < strings.length; i++) {
            String number = strings[i];
            number = number.replaceAll("[^\\d.]", "");

            if (number.isEmpty()) continue;
            float f = Float.parseFloat(number);

            floats[i] = f;
        }

        return floats;
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
        \n""");
    }
}
