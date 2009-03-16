import java.io.*;

public class HelloInterpreter {
    
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(args[0]));
        String input = reader.readLine();
        reader.close();
        if (input.equals("error")) {
          System.err.println("The HelloInterpreter will not greet 'error' under any circumstances.");
          System.exit(-1);
        }
        System.out.println("Hello, " + input + ".");
        System.exit(0);
    }
    
}
