package app;
import junit.framework.Assert;

public class appUnitTest2 {

    public static void main(String[] args) {
        Receipt rec = new Receipt();
        item nitem = new item("book",1,12.49,true,false);
        Assert.assertTrue(nitem.getPrice() == 12.49);
        Assert.assertTrue(nitem.getTax() == 0);

        item nitem2 = new item("Music CD",1,14.99,false,false);
        Assert.assertTrue(nitem2.getPrice() == 16.49);
        Assert.assertTrue(nitem2.getTax() == 1.5);

        item nitem3 = new item("Chocolate Bar",1,0.85,true,false);
        Assert.assertTrue(nitem3.getPrice() == 0.85);
        Assert.assertTrue(nitem3.getTax() == 0);



        rec.addItem(nitem);
        rec.addItem(nitem2);
        rec.addItem(nitem3);

        Assert.assertTrue(rec.getPrice() == 29.83);
        Assert.assertTrue(rec.getTax() == 1.5);
    }
}
