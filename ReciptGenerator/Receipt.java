package app;
import java.util.ArrayList;
import java.util.Scanner;


public class Receipt
{


    ArrayList<item> items = new ArrayList<item>();
    double tPrice,tTax = 0;

    public Receipt(){};

    public ArrayList<item> getItems(){
        return this.items;
    }

    public void addItem(item it){
        items.add(it);
        tPrice = tPrice + it.getPrice();
        tTax = tTax + it.getTax();
    }

    public double getPrice(){
        double price = (double) Math.round(this.tPrice * 100)/100;
        return price;
    }

    public double getTax(){
        double tax = (double) Math.round(this.tTax * 100)/100;
        return tax;
    }

    public void print(){
        System.out.println("\nReceipt: ");
        for(int i = 0;i < items.size();i++){
            items.get(i).print();
        }
        String out = "Sales Taxes: " + getTax() + "\nTotal: " + getPrice();
        System.out.println(out);
    }

    public void lst(){
        Scanner in = new Scanner(System.in);
        System.out.println("Enter receipt items: \n");
        while(true){
            System.out.println("Item name: ");
            String name = in.nextLine();

            System.out.println("\nItem Price: ");
            double price = in.nextDouble();

            System.out.println("\nIs the item a book, food or medical product? (y/n)");
            String ex = in.next();
            boolean exempt;
            if(ex.equals("y")){exempt = true;}else{exempt = false;}

            System.out.println("\nIs the item imported? (y/n)");
            String im = in.next();
            boolean imported;
            if(im.equals("y")){
                imported = true;
            }
            else{imported = false;}

            System.out.println("\nItem quantity: ");
            int quantity = in.nextInt();

            item nitem = new item(name,quantity,price,exempt,imported);
            this.addItem(nitem);

            System.out.println("\nContinue? (y/n): ");
            String cont = in.next();
            System.out.println(cont);
            if(cont.equals("n")){break;}
        }
        this.print();
    }

}