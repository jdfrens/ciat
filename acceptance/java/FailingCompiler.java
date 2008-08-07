import java.io.*;

public class FailingCompiler {
    
    public static void main(String[] args) throws IOException {
        PrintWriter printer = new PrintWriter(args[1]);
        printer.println("This compiler always fails.");
        printer.close();
        System.exit(127);
    }
    
}