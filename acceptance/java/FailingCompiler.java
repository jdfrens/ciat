import java.io.*;

public class FailingCompiler {
    
    public static void main(String[] args) {
        throw new RuntimeException("This compiler always fails!");
    }
    
}