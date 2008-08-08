import java.io.*;

public class HelloCompiler {
    
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(args[0]));
        String input = reader.readLine();
        reader.close();
        PrintWriter printer = new PrintWriter(args[1]);
        printer.println("Hello, " + input + ".");
        printer.close();
        System.exit(0);
    }
    
}