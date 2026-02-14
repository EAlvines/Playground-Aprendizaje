import java.util.Scanner;

public class Calculadora {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int opcion;
        String n;

        System.out.print("Ingresa Nombre: ");
        n = sc.next();

        do {
            System.out.println("\n ===================");
            System.out.println("\n CALCULADORA");
            System.out.println("\n ===================");
            System.out.println("1. Sumar");
            System.out.println("2. Restar");
            System.out.println("3. Multiplicar");
            System.out.println("4. Dividir");
            System.out.println("5. Salir");
            System.out.print("Elige una opción: ");

            
            opcion = sc.nextInt();

            if(opcion >= 1 && opcion <= 4) {
                System.out.print("Ingrese numero 1: ");
                double a = sc.nextDouble();

                System.out.print("Ingrese numero 2: ");
                double b = sc.nextDouble();

                switch ((opcion)) {
                    case 1:
                        System.out.println("Resultado: " + (a + b));
                        break;
                    case 2:
                        System.out.println("Resultado: " + (a-b));
                        break;
                    case 3:
                        System.out.println("Resultado: " + (a * b));
                        break;
                    case 4:
                        if (b == 0) {
                            System.out.println("Error: division entre 0");
                        } else {
                            System.out.println("Resultado: " + (a / b));
                        }
                        break;
                }
            } else if (opcion != 5) {
                System.out.println("Opcion invalida");
            }
        } while (opcion != 5);
        System.out.println("Gracias por usar la calculadora" + " " + n);
        sc.close();
    }
}