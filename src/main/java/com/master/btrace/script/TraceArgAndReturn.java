package com.master.btrace.script;

import com.sun.btrace.annotations.*;
import static com.sun.btrace.BTraceUtils.*;

@BTrace public class TraceArgAndReturn {

    @OnMethod(
            clazz = "com.master.btrace.server.HelloWorld",
            method = "execute",
            location = @Location(Kind.RETURN)
    )
    public static void traceHelloWorldExecute(@Self Object instance, int interval, @Return boolean result) {
        println("call HelloWorld.execute");
        println(strcat("sleepTime is:",str(interval)));
        println(strcat("sleepTotalTime is:",str(get(field("HelloWorld","sleepTotal"),instance))));
        println(strcat("return value is:",str(result)));
    }

}
