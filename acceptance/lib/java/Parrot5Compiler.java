import java.io.*;

public class Parrot5Compiler {
  
  public static void main(String[] args) throws IOException {
    if (args[0].matches(".*sad.*")) {
      System.err.println("The error you desire!");
      System.exit(-1);
    } else {
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
  
}