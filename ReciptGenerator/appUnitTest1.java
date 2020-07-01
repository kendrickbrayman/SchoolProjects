package app;
import junit.framework.Assert;

public class appUnitTest1 {

    public static void main(String[] args) {
        Receipt rec = new Receipt();
        item nitem = new item("Imported Bottle of Perfume",1,27.99,false,true);
        Assert.assertTrue(nitem.getPrice() == 32.19);
        Assert.assertTrue(nitem.getTax() == 4.2);

        item nitem2 = new item("Bottle of Perfume",1,18.99,false,false);
        Assert.assertTrue(nitem2.getPrice() == 20.89);
        Assert.assertTrue(nitem2.getTax() == 1.9);

        item nitem3 = new item("Packet of Headache Pills",1,9.75,true,false);
        Assert.assertTrue(nitem3.getPrice() == 9.75);
        Assert.assertTrue(nitem3.getTax() == 0);

        item nitem4 = new item("Imported Box of Chocolates",1,11.25,true,true);
        Assert.assertTrue(nitem4.getPrice() == 11.85);
        Assert.assertTrue(nitem4.getTax() == 0.6);

        rec.addItem(nitem);
        rec.addItem(nitem2);
        rec.addItem(nitem3);
        rec.addItem(nitem4);

        Assert.assertTrue(rec.getPrice() == 74.68);
        Assert.assertTrue(rec.getTax() == 6.70);
    }
}
