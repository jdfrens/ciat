import java.io.*;

public class HelloCompiler {
    
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(args[0]));
        String input = reader.readLine();
        reader.close();
        if (input.equals("error")) {
          System.err.println("The HelloCompiler will not greet 'error' under any circumstances.");
          System.exit(-1);
        }
        PrintWriter printer = new PrintWriter(args[1]);
        printer.println("Hello, " + input + ".");
        printer.close();
        System.exit(0);
    }
    
}