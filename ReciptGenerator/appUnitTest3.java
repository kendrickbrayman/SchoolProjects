package app;
import junit.framework.Assert;

public class appUnitTest3 {

    public static void main(String[] args) {
        Receipt rec = new Receipt();
        item nitem = new item("Imported box of Chocolates",1,10.00,true,true);
        Assert.assertTrue(nitem.getPrice() == 10.50);
        Assert.assertTrue(nitem.getTax() == 0.5);

        item nitem2 = new item("Imported Bottle of Perfume",1,47.50,false,true);
        Assert.assertTrue(nitem2.getPrice() == 54.65);
        Assert.assertTrue(nitem2.getTax() == 7.15);

        rec.addItem(nitem);
        rec.addItem(nitem2);

        Assert.assertTrue(rec.getPrice() == 65.15);
        Assert.assertTrue(rec.getTax() == 7.65);
    }
}
