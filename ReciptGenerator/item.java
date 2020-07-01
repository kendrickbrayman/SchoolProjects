package app;

public class item {
    String name;
    int quantity;
    double totalPrice;
    double tax;

    public item(){};

    public void setTax(double tax) {
        this.tax = tax;
    }
    public double getTax() {
        return tax;
    }

    public void setName(String name) {
        this.name = name;
    }
    public String getName() {
        return name;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public int getQuantity() {
        return quantity;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
    public double getPrice() {
        return totalPrice;
    }

    public item(String name, int quantity, double price, boolean exempt, boolean imported){
        this.setName(name);
        this.setQuantity(quantity);
        if(!exempt & !imported){
            this.setTax(Math.floor((Math.ceil(price * 0.1 / 0.05) * 0.05) * quantity * 100)/100);
        } else if(exempt) {
            if (!imported) {
                this.setTax(0);
            } else {
                this.setTax(Math.floor((Math.ceil(price * 0.05 / 0.05) * 0.05) * quantity * 100)/100);
            }
        }
        else{
            this.setTax(Math.floor((Math.ceil(price * 0.15 / 0.05) * 0.05) * quantity * 100)/100);
        }
        this.setTotalPrice((double)Math.round((price * quantity + this.getTax())*100)/100);
    }

    public void print(){
        String msg = "" + (int) getQuantity() + " " + getName() + ": " + getPrice() + "\n";
        System.out.println(msg);
    }


}