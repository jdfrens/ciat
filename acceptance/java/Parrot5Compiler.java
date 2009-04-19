import java.io.*;

public class Parrot5Compiler {
    
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(args[0]));
        String input = reader.readLine();
        reader.close();
        
        System.out.println(".sub main");
        System.out.println("\tprint 5");
        System.out.println("\tprint \"\\n\"");
        System.out.println(".end");
        
        System.exit(0);
    }
    
}