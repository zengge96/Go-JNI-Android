package com.aghajari;

public class Native {

    static {
        System.loadLibrary("native-lib-go");
    }

    public static native String helloWorld();
    public static native int integerTest();

}
