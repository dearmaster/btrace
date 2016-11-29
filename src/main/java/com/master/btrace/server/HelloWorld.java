package com.master.btrace.server;

public class HelloWorld {

    private static HelloWorld instance;

    private int sleepTotal = 0;

    private HelloWorld() {}

    public static HelloWorld getInstance() {
        if(null == instance) {
            synchronized(HelloWorld.class) {
                if(null == instance) {
                    instance = new HelloWorld();
                }
            }
        }
        return instance;
    }

    public static void main(String[] args) {
        HelloWorld demo = new HelloWorld();
        for(int i=0; i<10; i++) {
            demo.execute(2);
        }
    }

    /**
     * To demo the trace of argument and return value
     * @param interval
     * @return
     */
    private boolean execute(int interval) {
        System.out.println("Sleep " + interval + " seconds....");
        try {
            Thread.sleep(interval * 1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        sleepTotal += interval;
        return true;
    }


}