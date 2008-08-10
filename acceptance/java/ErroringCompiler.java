import java.io.*;

public class ErroringCompiler {
    
    public static void main(String[] args) throws IOException {
        PrintWriter printer = new PrintWriter(args[1]);
        printer.println("This compiler always quits with an error.");
        printer.close();
        System.exit(127);
    }
    
}