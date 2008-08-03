import java.io.*;

public class Parrot5Compiler {
    
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(args[0]));
        String input = reader.readLine();
        reader.close();
        
        PrintWriter printer = new PrintWriter(args[1]);
        printer.println(".sub main");
        printer.println("\tprint 5");
        printer.println("\tprint \"\\n\"");
        printer.println(".end");
        printer.close();
        
        System.exit(0);
    }
    
}