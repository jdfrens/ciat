import java.io.*;

public class SalveInterpreter {
    
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(args[0]));
        String input = reader.readLine();
        reader.close();
        System.out.println("salve, " + input + ".");
        System.exit(0);
    }
    
}
